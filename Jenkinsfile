env.LC_ALL="en_US.UTF-8"

node {
    checkout(scm)
    sh("git clean -fdx")
}

stage "Lint"
node {
  sh('chef exec rake lint')
}

stage "Unit"
node {

  sh('chef exec berks install')
  sh('chef exec rake unit')
}

stage "Functional"
node {
  create_kitchen_docker_yaml()
  env.KITCHEN_LOCAL_YAML=".kitchen.aws.yml"
  sh('chef exec rake functional')
}

if(env.BRANCH_NAME == "master") {
  sh('berks upload')
}

def create_kitchen_docker_yaml() {
  if (fileExists('.kitchen.aws.yml')) {
      echo('Using the cookbooks .kitchen.aws.yml')
  } else {
      echo('Placing default .kitchen.aws.yml file in workspace')
      sh('chef exec rake kitchen:aws')
  }
}
