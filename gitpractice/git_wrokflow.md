git config –global usern.name ”myusername”
git config –global usern.email “myemail”

echo "Hello from mainfile" > mainfile.txt
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/Dineshkumar40/guvi_devops.git
git branch -M main
git push -u origin main
It asks for username and git token everytime we push

Merge:
git checkout -b feature
echo “Hello from featurefile” > featurefile.txt
git add .
git commit -m "feature branch Initial commit"
git push -u origin main 
git checkout main
git merge feature
git push origin main

Rebase:
git checkout -b update
echo "Rebase branch changes" > update.txt
git add update.txt
git commit -m "Added update file"
git checkout main
echo "Main branch update" >> mainfile.txt
git add mainfile.txt
git commit -m "Updated main file"
git checkout update
git rebase main
git push -u origin update

git checkout main
git pull origin main
git merge update
