#!/usr/bin/env bash

set -e

usage() {
  cat << EOS
usage: $0 [options]

Options:
  -t           Move old branches to trash/ (see -a)
  -a <time>    Specify the minimum age for trashing a branch. Implies -t. Default: 14d
  -e           Remove all branches under trash/
  -m           Remove all merged branches
  -r           Clean remote branches instead of local branches
  -w           Perform a "what if" dry-run. Only prints out actions that would have been performed.
  -h           Shows this message and quits.
EOS
}

branchWhitelist=.git-branch-whitelist

cutoffOffset=14d
branchOpts=
emptyTrash=false
deleteMerged=false
whatIf=false
remote=false
trashOldBranches=false

while getopts 'hemo:wr' OPTION; do case $OPTION in
  h) usage; exit;;
  e) emptyTrash=true;;
  m) deleteMerged=true;;
  a) cutoffOffset=$OPTARG;&
  t) trashOldBranches=true;;
  w) whatIf=true;;
  r) remote=true;;
  ?) usage; exit -1;;
esac; done

if $remote; then
  branchOpts='--remote';
  masterBranch='origin/master';
else
  masterBranch='master';
fi

cutoff=$(date -v -${cutoffOffset} +%s)

if $whatIf; then
  deleteVerb='Would delete'
  moveVerb='Would move'
else
  deleteVerb='Deleting'
  moveVerb='Moving'
fi

egrepOpts=('-e (^|/)trash/')
if ! $emptyTrash; then
  sources+=("<()")
  # don't include pointers, i.e. foo -> bar
  egrepOpts+=('-v' "-e ^${masterBranch}\$" '-e \->')

  if [[ -e $branchWhitelist ]]; then
    egrepOpts+=("-f $branchWhitelist")
  fi
fi

moveBranch() {
  removteName=$1
  oldBranch=$2
  newBranch=$3
  reason=$4

  echo "$moveVerb $oldBranch -> $newBranch ($reason)"

  if $whatIf; then return; fi

  if $remote; then
    git push $remoteName "$oldBranch:refs/heads/$newBranch"
    git push --delete $remoteName $remoteBranch
  else
    git branch $newBranch $oldBranch
    git branch -D $oldBranch
  fi
}

deleteBranch() {
  remoteName=$1
  oldBranch=$2
  reason=$3

  echo $deleteVerb $remoteName $oldBranch

  if $whatIf; then return; fi

  if [[ -z $remoteName ]]; then
    git branch -D $oldBranch
  else
    git push --delete $remoteName $oldBranch
  fi
}

if $deleteMerged; then
  git branch $branchOpts --merged $masterBranch | cut -c 3- | egrep -v -e "^${masterBranch}\$" -e '\->' | {
    while read branch; do
      if $remote; then
        remoteName=${branch%%/*}
        branchName=${branch#*/}
      else
        branchName=$branch
      fi

      deleteBranch "$remoteName" $branchName 'merged'
    done
  }
fi

if $trashOldBranches || $emptyTrash; then
  git branch $branchOpts --no-merged $masterBranch | cut -c 3- | egrep ${egrepOpts[@]} | {
    while read branch; do
      if $remote; then
        remoteName=${branch%%/*}
        oldBranch=${branch#*/}
      else
        oldBranch=$branch
      fi

      newBranch=trash/$oldBranch

      if $emptyTrash; then
        deleteBranch "$remoteName" $oldBranch 'in trash'
      else
        branchDate=$(git show -s --format=%ct $branch)

        if [ "$branchDate" -lt "$cutoff" ]; then
          moveBranch "$remoteName" $oldBranch $newBranch "last commit was on $(date -j -f %s $branchDate)"
        fi
      fi
    done
  }
fi
