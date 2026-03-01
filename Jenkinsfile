pipeline {
    agent any

    stages {

        stage('Checkout from GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/rushindrareddyyasa/node-k8s-app.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t my-k8s-app:${BUILD_NUMBER} .
                docker tag my-k8s-app:${BUILD_NUMBER} yasareddy02/my-k8s-app:${BUILD_NUMBER}
                '''
            }
        }

       stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-cred') {
                        sh 'docker push yasareddy02/my-k8s-app:${BUILD_NUMBER}'
                    }
                }
            }
        }

        stage('Start Minikube if not running') {
    steps {
        sh '''
        echo "Checking Minikube status..."

        if ! minikube status | grep -q "apiserver: Running"; then
            echo "Minikube not healthy. Deleting old profile..."

            minikube delete || true

            echo "Starting fresh Minikube..."
            minikube start --driver=docker --memory=3072 --cpus=2

            echo "Waiting for node to be ready..."
            kubectl wait --for=condition=Ready nodes --all --timeout=180s
        else
            echo "Minikube already running and healthy."
        fi
        '''
    }
}

        stage('Deploy to Kubernetes') {
    steps {
        sh '''
        echo "Loading Docker image into Minikube..."
        minikube image load yasareddy02/my-k8s-app:${BUILD_NUMBER}

        echo "Applying Kubernetes manifests..."
        minikube kubectl -- apply -f k8s/deployment.yaml
        minikube kubectl -- apply -f k8s/service.yaml

        echo "Checking pods..."
        minikube kubectl -- get pods -o wide

        echo "Service URL:"
        minikube service my-k8s-app-service --url
        '''
    }
}
    }
}
