# Gotsha CI (WIP)

## What?
Gotsha should be a tiny tool that will let you “sign off” your commit locally by running tests and linters, and then recording the commit SHA. Your pull request can then be verified against that record, so reviewers (and GitHub) know you actually ran the checks before asking for review.

## Why?
Instead of pushing everything to CI, you can run the same checks locally (faster, cheaper, works offline) and prove you did it.
Gotsha will make this proof visible in your repo via a simple file.
