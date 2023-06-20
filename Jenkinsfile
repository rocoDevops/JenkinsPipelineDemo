pipeline{
    //It means the job can run in any node Master or Slave. Also we can select the label as well
    //Where you want to execute this Jenkins Pipeline.
    //agent any
    agent {label 'worker'}
    //Options basically conatins the general configuration of the job 
    options{
        buildDiscarder(logRotator(daysToKeepStr: '15'))
        disableConcurrentBuilds()
        //Sometimes Jenkins job takes longer time to execute than usual. We can mention timeout in 10 minutes. 
        timeout(time:1, unit: 'MINUTES')
        //If there is some network failure please retry the job 3 times
        retry(3)
    }
    //If you want to take input from user at run time. We have to declare Parameter. 
    parameters{
        string(name: 'BRANCH', defaultValue: 'develop')
        choice(name: 'ENV', choices: ['DEV','QA','PROD','Test'])
        booleanParam(name: 'TEST_CASES', defaultValue: true)
    }
    triggers { 
        pollSCM "*/10 * * * *" 
        cron "0 0 * * *" 
    }
    
    //It will contain the actual stages you want to execute. Stages block will contain multiple stages. Each
    //stage will contain the actaul steps to execute.
    stages{
        stage('First Stage'){
            steps{
                sh "echo Hello from Jenkins Pipe"
                sh "sleep 10"
            }
        }
        stage('Test Stage'){
            parallel{
                stage('Linux Stage'){
                    steps{
                        sh "echo we are in Linux Stage"
                        sh "sleep 60"
                    }
                }
                stage('Windows Stage'){
                    steps{
                        sh "echo we are in Windows Stage"
                        sh "sleep 60"
                    }
                }

            }
        }
         
    }
    //If we want to execute the steps always without any failure irespective of time 
    post{
        always{
            echo "I will always RUN"
        }
    }

}