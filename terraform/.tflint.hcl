plugin "terraform" {
  enabled = true
  preset = "recommended"
}

plugin "aws" {
    enabled = true
    version = "0.32.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# 適切な記述をしている場合でも、Warningが出るため無効化
rule "terraform_required_version" {
  enabled = false
}

# 適切な記述をしている場合でも、Warningが出るため無効化
rule "terraform_required_providers" {
  enabled = false
}
