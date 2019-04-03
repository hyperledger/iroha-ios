node('mac_for_ios') {
  scmVars = checkout scm
  try {
    grpc = "protoc-gen-objcgrpc"
    withEnv(['IROHA_PATH=iroha',
            'SCHEMA_PATH=Schema',
            'PROTO_GEN=ProtoGen',
            'LANG=en_US.UTF-8']) {
      stage('prepare') {
        if (scmVars.GIT_LOCAL_BRANCH == 'master' || env.CHANGE_TARGET == 'master' ) {
          sh(script: "git clone -b master --depth=1 https://github.com/hyperledger/iroha")
          sh(script: "mkdir \$SCHEMA_PATH")
          sh(script: "cp -R \$IROHA_PATH/shared_model/schema \$SCHEMA_PATH/proto")
          sh(script: "mkdir \$PROTO_GEN-iroha")
          sh(script: "protoc --plugin=protoc-gen-grpc=\$(command -v ${grpc}) --objc_out=\$PROTO_GEN-iroha --grpc_out=\$PROTO_GEN-iroha --proto_path=./\$SCHEMA_PATH/proto ./\$SCHEMA_PATH/proto/*.proto")
          difference = sh(script: "diff -r \$PROTO_GEN-iroha \$PROTO_GEN | grep \$PROTO_GEN-iroha | awk '{print \$4}'", returnStdout: true)
          if (difference.length() > 0) {
            echo "Differences in protofiles:\n ${difference}"
            currentBuild.result = 'UNSTABLE'
          }
        }
      }
      stage('test') {
        sh(script: "pod lib lint --verbose")
      }
      stage('release') {
        checkTag = sh(script: 'git describe --tags --exact-match ${GIT_COMMIT}', returnStatus: true)
        if (scmVars.GIT_LOCAL_BRANCH == 'master' && checkTag == 0 && currentBuild.result == 'SUCCESS') {
          sh(script: "pod trunk push")
        }
      }
    }
  } // end try
  catch(Exception e) {
    currentBuild.result = 'FAILURE'
  } // end catch
  finally {
    cleanWs()
  }
} //end node


