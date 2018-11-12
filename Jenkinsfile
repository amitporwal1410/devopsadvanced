node {
  try {
    stage('Checkout') {
        checkout scm
    }
    stage('Environment') {
        sh 'git --version'
        echo "Branch: ${env.BRANCH_NAME}"
        sh 'docker -v'
        sh 'printenv' 
        sh 'echo $USER'
    }
    stage('Set Up GCloud') {
        sh 'CLOUDSDK_CORE_DISABLE_PROMPTS=1'
        sh 'curl https://sdk.cloud.google.com | bash > /dev/null;'
        sh '/var/lib/jenkins/google-cloud-sdk/bin/gcloud components update kubectl'
        sh '/var/lib/jenkins/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file friendly-retina-208018-62ea382a3153.json'
        sh '/var/lib/jenkins/google-cloud-sdk/bin/gcloud config set project friendly-retina-208018'
        sh '/var/lib/jenkins/google-cloud-sdk/bin/gcloud config set compute/zone us-central1-a'
        sh '/var/lib/jenkins/google-cloud-sdk/bin/gcloud container clusters get-credentials devopsadvanced'
    } 
    stage('Build Docker'){
        sh 'echo "mytempdockerpass" | docker login -u "porwalamit" --password-Ap@9893854355'
        sh 'docker build -t porwalamit/devopsadvanced .'
        sh 'docker build -t porwalamit/devopsadvancedredis -f Dockerfile.redis .'
    }
    stage('Docker Image Test'){
        sh 'docker run --name m-node-512 porwalamit/devopsadvanced echo 1'
        sh 'docker run --name m-redis-512 porwalamit/devopsadvanced echo 2'
    }
    stage('Push Fresh Docker Hub Images'){
       sh 'docker build -t porwalamit/devopsadvanced:latest -t porwalamit/devopsadvanced:$(git rev-parse HEAD) .'
        sh 'docker build -t porwalamit/devopsadvancedredis:latest -t porwalamit/devopsadvancedredis:$(git rev-parse HEAD) -f Dockerfile.redis .'
        sh 'docker push porwalamit/devopsadvanced:latest'
        sh 'docker push porwalamit/devopsadvancedredis:latest'
        sh 'docker push porwalamit/devopsadvanced:$(git rev-parse HEAD)'
        sh 'docker push porwalamit/devopsadvancedredis:$(git rev-parse HEAD)'
    }
    stage('Deploy To k8s'){
        sh 'kubectl apply -f k8s'
        sh 'kubectl set image deployments/node-server-deployment node-server-deployment=porwalamit/devopsadvanced:$(git rev-parse HEAD)'
        sh 'kubectl set image deployments/redis-server-deployment redis-server-deployment=porwalamit/devopsadvancedredis:$(git rev-parse HEAD)'
    }
    stage('Post Cleanup'){
        sh 'docker stop m-node-512'
        sh 'docker container rm m-node-512'
        sh 'docker stop m-redis-512'
        sh 'docker container rm m-redis-512'
    }
  }catch (err) {
    throw err
  }
}
