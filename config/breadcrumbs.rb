crumb :root do
  link 'Home', root_path
end

crumb :sign_in do
  link '로그인', (url_for '/sign_in')
  parent :root
end

crumb :sign_up do
  link '가입', (url_for '/sign_up')
  parent :root
end

crumb :password_reset do
  link '비밀번호 재설정', (url_for '/password-reset')
  parent :root
end

crumb :profile do
  link '프로필', (url_for '/profile')
  parent :root
end

crumb :about do
  link '밤딸기', (url_for '/about')
  parent :root
end

crumb :develop do
  link '개발', (url_for '/develop')
  parent :about
end

crumb :oneline do
  link '게시판', (url_for '/oneline')
  parent :about
end

crumb :article_list do
  parent :about
  if request.env['PATH_INFO'].include? '/notice'
    link '공지', (url_for '/notice')
  else
    link '게시판', (url_for '/board')
  end
end

crumb :article_view do
  parent :article_list
  link '게시글', (url_for '/')
end

crumb :donate do
  link '기부', (url_for '/donate')
  parent :about
end

crumb :terms_of_service do
  link '이용 약관', (url_for '/terms_of_service')
  parent :about
end

crumb :minecraft_about do
  link '마인크래프트', (url_for '/minecraft/about')
  parent :root
end

crumb :minecraft_rules do
  link '규칙', (url_for '/minecraft/rules')
  parent :minecraft_about
end

crumb :minecraft_connect do
  link '접속', (url_for '/minecraft/connect')
  parent :minecraft_about
end

crumb :minecraft_maps do
  link '지도', (url_for '/minecraft/maps')
  parent :minecraft_about
end

crumb :multiplays_about do
  link '다른 게임들', (url_for '/multiplay/about')
  parent :root
end

crumb :multiplays_ottd do
  link 'OpenTTD', (url_for '/multiplay/ottd')
  parent :multiplays_about
end

crumb :multiplays_orct do
  link 'OpenRCT2', (url_for '/multiplay/orct')
  parent :multiplays_about
end


# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
