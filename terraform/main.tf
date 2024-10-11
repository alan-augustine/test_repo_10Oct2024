
# S3 bucket 
resource "aws_s3_bucket" "codebuild-10oct2024-a" {
  bucket = "codebuild-10oct2024-a"
}


########### IAM role

import {
  to = aws_iam_policy.CodeBuildBasePolicy_codebuild_10oct2024_a_us_east_1
  id = "arn:aws:iam::751172565057:policy/service-role/CodeBuildBasePolicy-codebuild-10oct2024-a-us-east-1"
}

resource "aws_iam_policy" "CodeBuildBasePolicy_codebuild_10oct2024_a_us_east_1" {
  name = "CodeBuildBasePolicy-codebuild-10oct2024-a-us-east-1"
  description = "Policy used in trust relationship with CodeBuild"
  path = "/service-role/"
  policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
                            "logs:CreateLogGroup",
                            "logs:CreateLogStream",
                            "logs:PutLogEvents",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "arn:aws:logs:us-east-1:751172565057:log-group:/aws/codebuild/codebuild-10oct2024-a",
                            "arn:aws:logs:us-east-1:751172565057:log-group:/aws/codebuild/codebuild-10oct2024-a:*",
                        ]
                    },
                    {
                        Action   = [
                            "s3:PutObject",
                            "s3:GetObject",
                            "s3:GetObjectVersion",
                            "s3:GetBucketAcl",
                            "s3:GetBucketLocation",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "arn:aws:s3:::codepipeline-us-east-1-*",
                        ]
                    },
                    {
                        Action   = [
                            "s3:PutObject",
                            "s3:GetObject",
                            "s3:GetBucketAcl",
                            "s3:GetBucketLocation",
                            "s3:ListBucket",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "arn:aws:s3:::codebuild-10oct2024-a",
                            "arn:aws:s3:::codebuild-10oct2024-a/*",
                        ]
                    },
                    {
                        Action   = [
                            "codebuild:CreateReportGroup",
                            "codebuild:CreateReport",
                            "codebuild:UpdateReport",
                            "codebuild:BatchPutTestCases",
                            "codebuild:BatchPutCodeCoverages",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "arn:aws:codebuild:us-east-1:751172565057:report-group/codebuild-10oct2024-a-*",
                        ]
                    },
                ]
                Version   = "2012-10-17"
            }
        )
}

import {
  to = aws_iam_role.codebuild_codebuild_10oct2024_a_service_role
  id = "codebuild-codebuild-10oct2024-a-service-role"
}

resource "aws_iam_role" "codebuild_codebuild_10oct2024_a_service_role" {
  name = "codebuild-codebuild-10oct2024-a-service-role"
  path = "/service-role/"
  assume_role_policy    = jsonencode(
           {
             Statement = [
                 {
                     Action    = "sts:AssumeRole"
                     Effect    = "Allow"
                     Principal = {
                         Service = "codebuild.amazonaws.com"
                       }
                 },
               ]
             Version = "2012-10-17"
           }
       )
}

resource "aws_iam_role_policy_attachment" "codebuild_codebuild_10oct2024_a_service_role_attach" {
  role       = aws_iam_role.codebuild_codebuild_10oct2024_a_service_role.name
  policy_arn = aws_iam_policy.CodeBuildBasePolicy_codebuild_10oct2024_a_us_east_1.arn
}

############ CodeBuild Resource

resource "aws_codebuild_project" "codebuild_10oct2024_a" {
    name = "codebuild-10oct2024-a"
    service_role = "arn:aws:iam::751172565057:role/service-role/codebuild-codebuild-10oct2024-a-service-role"
    build_timeout = 15
    badge_enabled = true
    artifacts {
        encryption_disabled    = false
        location               = "codebuild-10oct2024-a"
        name                   = "devbuilds"
        namespace_type         = "NONE"
        override_artifact_name = false
        packaging              = "NONE"
        path                   = null
        type                   = "S3"
    }
    environment {
        certificate                 = null
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
        image_pull_credentials_type = "CODEBUILD"
        privileged_mode             = false
        type                        = "LINUX_CONTAINER"
    }
    logs_config {
        cloudwatch_logs {
            status      = "ENABLED"
        }
        s3_logs {
            status              = "DISABLED"
        }
    }
    source {
        buildspec           = null
        git_clone_depth     = 1
        insecure_ssl        = false
        location            = "https://github.com/alan-augustine/test_repo_10Oct2024.git"
        report_build_status = false
        type                = "GITHUB"
        git_submodules_config {
            fetch_submodules = false
        }
    }
}