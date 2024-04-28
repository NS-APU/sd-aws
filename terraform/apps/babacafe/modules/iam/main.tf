resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
  ]
}

resource "aws_iam_role_policy" "kms_decrypt_policy" {
  name = "${var.app-name}_ecs_task_execution_role_policy_kms"
  role               = aws_iam_role.ecs_task_execution_role.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "kms:Decrypt",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "rds-db:connect",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketVersions", 
          "s3:GetBucketACL", 
          "s3:*Object", 
        ],
        "Resource": "*"
      },
    ]
  })
}
