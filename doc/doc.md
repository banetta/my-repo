--- Git 명령어 실습
- 로컬저장소 관리
# mkdir git-test && cd $_
# vi README.txt
Hello World
# git init -b main
# git config --global user.email "test@example.com"
# git config --global user.name "johnlee"
# git add README.txt
# git commit -m "add site"
# echo "Aloha" >> README.txt
# git add README.txt
# git commit -m "add update"
# git log
# cat README.txt
Hello World
Aloha

# git checkout 776e5fded06e850941fd79732aa7fc005612ec4d
# cat README.txt
Hello World

# git checkout -
# cat README.txt
Hello World
Aloha

- GitHub 원격저장소 커밋
# git remote add origin https://github.com/hangi2025/my-repo.git
# git push origin main

- GitHub 원격저장소의 커밋을 로컬저장소에 내려받기
# git clone https://github.com/hangi2025/my-repo.git
# cd my-repo
# cat README.txt
# echo "NIHAO" >> README.txt
# git add README.txt
# git commit -m "add list"
# git push origin main # 윈 10 자격 증명 관리자 > Windows 자격 증명 > 일반 자격 증명 > git:https://github.com > id와 token 정보

- 원격저장소의 새로운 커밋을 로컬저장소에 갱신하기
# cat README.txt
# git pull origin main
# cat README.txt

- 제거
# git rm README.txt
# git commit -m "remove README"
# git push origin main

- 갱신
# git pull origin main

--- Dockerfile 작성
# git clone https://github.com/hangi2025/docker-hub.git
# cd docker-hub
# tar xvf ~/sale.tar -C ./
# vi Dockerfile
FROM nginx:latest
ENV path=/usr/share/nginx
COPY index.html $path/html
COPY inner-page.html $path/html
COPY portfolio-details.html $path/html
COPY assets $path/html/assets
COPY forms $path/html/forms
WORKDIR $path/html
CMD ["nginx", "-g", "daemon off;"]

--- main.yaml 작성 (docker-hub/.github/workflows/main.yaml)
# vi .github/workflows/main.yaml
name: Deploy to Docker Hub

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
env:
  DOCKER_REPOSITORY: johnlee0405/docker-repo
  DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
  DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    environment: production

    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Login to Docker Hub
      run: |
        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
    - name: Build, tag, and push image to Docker Hub
      id: build-image
      run: |
        GIT_HASH=$(git rev-parse --short "$GITHUB_SHA")
        docker build -t $DOCKER_REPOSITORY:$GIT_HASH .
        docker push $DOCKER_REPOSITORY:$GIT_HASH
        echo "::set-output name=image::$DOCKER_REPOSITORY:$GIT_HASH"
        
    - name: Repository checkout
      uses: actions/checkout@v2
      with:
        repository: hangi2025/argocd-kube
        token: ${{ secrets.MY_GITHUB_TOKEN }}

    - name: Add date and push
      run: |
        GIT_HASH=$(git rev-parse --short "$GITHUB_SHA")
        sed -i "16s|.*|      - image: $DOCKER_REPOSITORY:$GIT_HASH|g" deployment.yaml
        git add .
        git config --global user.email "github-actions@github.com"
        git config --global user.name "github-actions"
        git commit -am "Inject Tag"
        git push

:!mkdir -p %:h
:w

# git add .
# git commit -m "add files01"
# git push origin main

DOCKER_PASSWORD
DOCKER_USERNAME
MY_GITHUB_TOKEN

# git clone https://github.com/hangi2025/argocd-kube.git
# cd argocd-kube
# vi deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: argocd-kube-deploy
spec:
  replicas: 2 (pod 갯수 설정하는 부분)
  selector:
    matchLabels:
      run: argocd-kube
  template:
    metadata:
      labels:
        run: argocd-kube
    spec:
      containers:
      - image: 
        name: 

# vi serve.yml (명령어 테스트용?)
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    run: pod
  ports:
    - protocol: TCP
      port: 80
  type: LoadBalancer
  externalIPs:
    - 172.16.0.201
    
# vi service.yaml
apiVersion: v1
kind: Service
metadata:
  name: argocd-kube-svc
spec:
  ports:
  - port: 80
  selector:
    run: argocd-kube
  type: LoadBalancer
  externalIPs:
  - 172.16.0.201

# git add .
# git commit -m "add files01"
# git push origin main

# systemctl start kubelet
# systemctl status kubelet

--- ArgoCD
# kubectl create namespace argocd
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
# kubectl get svc -n argocd
# kubectl edit svc -n argocd argocd-server
