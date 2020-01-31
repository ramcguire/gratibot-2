pipeline {
  agent none
  environment {
    SLACK_CHANNEL="gratibot-2"
  }
  stages {
    stage('Build') {
      agent {
        label "lead-toolchain-skaffold"
      }
      steps {
        container('skaffold') {
          sh "skaffold build --file-output=image.json"
          stash includes: 'image.json', name: 'build'
          sh "rm image.json"
        }
      }
    }
    stage('Deploy to Staging') {
      agent {
        label "lead-toolchain-skaffold"
      }
      when {
        beforeAgent true
        branch 'master'
      }
      environment {
        TILLER_NAMESPACE      = "${env.stagingNamespace}"
        ISTIO_DOMAIN          = "${env.stagingDomain}"
      }
      steps {
        container('skaffold') {
          unstash 'build'
          sh "skaffold deploy -a image.json -n ${TILLER_NAMESPACE}"
        }
        stageMessage "Successfully deployed to staging:\ngratibot2.${env.stagingDomain}"
      }
    }
  }
}
