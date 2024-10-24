resource "aws_iam_user" "workshop_user" {
  count = var.participant_count
  name  = "workshop_user_${count.index + 1}"
}

resource "aws_iam_access_key" "workshop_user_key" {
  count = var.participant_count
  user  = aws_iam_user.workshop_user[count.index].name
}
