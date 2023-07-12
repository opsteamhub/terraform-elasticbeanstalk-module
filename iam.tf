resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWebTier" {
  for_each = var.environment
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role       = aws_iam_role.ec2_role[each.key].name
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWorkerTier" {
  for_each = var.environment
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
  role       = aws_iam_role.ec2_role[each.key].name
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkMulticontainerDocker" {
  for_each = var.environment
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
  role       = aws_iam_role.ec2_role[each.key].name
}

resource "aws_iam_role" "ec2_role" {
  for_each = var.environment
  name = join("-", [var.application, each.key, "role"])

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "profile" {
  for_each = var.environment
  name = aws_iam_role.ec2_role[each.key].name
  role = aws_iam_role.ec2_role[each.key].name
}