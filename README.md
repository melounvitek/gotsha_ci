# Gotsha — your local CI
Pushing untested commits? Gotsha!

## What is it?
Gotsha is a tiny tool that lets you “sign off” your commit locally by running tests and linters, and then recording the commit SHA (hence the gem name: got-SHA). Your pull request can then be verified against that record, so reviewers (and GitHub) know you actually ran the checks before asking for review.

<img width="843" height="301" alt="image" src="https://github.com/user-attachments/assets/2879ec9a-0cec-462c-91dc-d357e1a0d34d" />

And the best part? It all happens automatically!

<img width="734" height="699" alt="image" src="https://github.com/user-attachments/assets/b2e5a226-3d8c-4ef7-a588-af8863d63b8c" />

Based on your workflow and tests speed, you can configure them to auto-run on every commit, before every push, or just manually. Whenever pushing to remote repository, the Git notes (which is what's used to store the test results) get sent there as well.

## Why?
Instead of pushing everything to CI, you can run the same checks locally (faster, cheaper, works offline) and prove you did it.
Gotsha will make this proof visible in your pull request.

## When, how?
So far, this is just a quick proof of concept. When I will have something ready to be used by other people, I will update the documentation with details. I track the most important features left to be implemented in issues.
