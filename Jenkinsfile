pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "882246222011"
        AWS_REGION = "ap-northeast-2"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_NAME = "python-web-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        HELM_CHART_PATH = "helm/python-web-app"  // Helm 차트 경로 (저장소 내)
        GIT_REPO_URL = "https://github.com/kchlee315/cicdtest2"
    }

    stages {
        stage('Checkout') {
            steps {
                git "${GIT_REPO_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    docker.image("${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}").push()
                }
            }
        }

        stage('Update Helm Chart') {
            steps {
                script {
                    // Update the values.yaml with new image tag
                    sh """
                        cd ${HELM_CHART_PATH}
                        sed -i 's|repository: .*|repository: ${ECR_REGISTRY}/${IMAGE_NAME}|' values.yaml
                        sed -i 's|tag: .*|tag: "${IMAGE_TAG}"|' values.yaml
                    """

                    // Package the Helm chart
                    sh "helm package ${HELM_CHART_PATH}"

                    // Move the packaged chart to a designated directory
                    sh "mkdir -p packaged-charts"
                    sh "mv ${IMAGE_NAME}-*.tgz packaged-charts/"

                    // Update the Helm repository index
                    sh "helm repo index packaged-charts --url https://raw.githubusercontent.com/your-username/your-python-web-app/main/packaged-charts"

                    // Commit and push changes
                    sh """
                        git config user.email "jenkins@example.com"
                        git config user.name "Jenkins"
                        git add ${HELM_CHART_PATH}/values.yaml packaged-charts
                        git commit -m "Update Helm chart for build ${BUILD_NUMBER}"
                        git push origin main
                    """
                }
            }
        }
    }
}
