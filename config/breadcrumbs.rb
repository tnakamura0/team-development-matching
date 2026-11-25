crumb :recruitments do
  link t("breadcrumbs.recruitments"), root_path
end

crumb :show_recruitment do |recruitment|
  link t("breadcrumbs.show_recruitment"), recruitment_path(recruitment)
  parent :recruitments
end

crumb :new_recruitment do
  link t("breadcrumbs.new_recruitment"), new_recruitment_path
  parent :recruitments
end

crumb :edit_recruitment do |recruitment|
  link t("breadcrumbs.edit_recruitment"), edit_recruitment_path(recruitment)
  parent :show_recruitment, recruitment
end

crumb :mypage do |user|
  link t("breadcrumbs.mypage"), user_path(user)
  parent :recruitments
end

crumb :edit_profile do |user|
  link t("breadcrumbs.edit_profile"), edit_user_path(user)
  parent :mypage, user
end
