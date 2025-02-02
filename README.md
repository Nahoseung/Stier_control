# Stier_control
### Git hub 연동하는 법
  1. $ git clone https://github.com/Nahoseung/Stier_control.git
  2. git clone https://<YOUR_GITHUB_USERNAME>:<YOUR_PERSONAL_ACCESS_TOKEN>@github.com/Nahoseung/Stier_control.git

### branch 만들기
  2. $ git branch [branch name]

  3. $ git switch [branch name] //자신의 branch 생성및 현재 local git의 repository를 해당 branch로 이동
     
## add commit push
  ### 해당 git hub에 업로드 하려는 경우
   clone 한 위치에서 
  
  1. $ git add .
  2. $ git commit -m " [write your commit messages]"
  3. $ git push
     
       * $ git push --set-upstream origin [branch name]
         //초기에 push하는 경우 remote branch와 자신의 local branch를 연동

  




