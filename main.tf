# Configure the GitHub Provider
provider "github" {
  token 	   = "${var.github_token}"
  organization = "${var.GITHUB_ORGANIZATION}"
}


#create repo
resource "github_repository" "my_repo" {
  name        = "${var.repo_name}"
  description = "${var.repo_description}"
}


#3 labels
resource "github_issue_label" "bug_label" {
  repository = "${github_repository.my_repo.name}"
  name       = "my_bug"
  color      = "FF0000"
}

resource "github_issue_label" "task_label" {
  repository = "${github_repository.my_repo.name}"
  name       = "my_task"
  color      = "0000FF"
}

resource "github_issue_label" "idea_label" {
  repository = "${github_repository.my_repo.name}"
  name       = "my_idea"
  color      = "00FF00"
}

#define user, to setup restriciton
data "github_user" "dany" {
	username = "Dany4Forter"
}


#setup branch protection
resource "github_branch_protection" "task" {
  repository = "${github_repository.my_repo.name}"
  branch = "master"
  enforce_admins = true		#enforce checks also for admins

  	required_status_checks {
    strict = false
  }

  #restrice who may push
  restrictions {
    users = ["${data.github_user.dany.username}"]
  }
}