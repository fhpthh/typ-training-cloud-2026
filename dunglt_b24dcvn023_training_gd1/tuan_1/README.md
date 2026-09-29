### 1
Git là một hệ thống quản lí phiên bản mã nguồn mở. Cho phép dev theo dõi,lưu lại lịch sử thay đổi của source code và làm việc nhóm hiệu quản
Git giúp lưu trữ các thay đổi code, xem ai đã sửa, đã sửa gì và lức nào sửa
công dụng-quản lí lịch sử xem lại thay đổi trong code
         -tách nhánh cho phép các member làm việc trên các tính năng khác nhau độc lập kh ảnh hưởng main 
         -phân tán: mỗi lap đều có repo riêng đày đủ code ,không phụ thuộc lap trung tâm


LÝ DO GIT ĐƯỢC TẠO RA?
Git được linux torvalds tạo ra năm 2005 để phục vụ việc phất triển nhân linux (kernel)
Ngày xưa linux là dự án mã nguồn mở để hàng nghìn dev đóng góp code.
Nhiều người dùng quá làm linux bị quá tải xong phải chuyển qua bitkeeper
Có người thiết kế ngược giao thức của bitkeeper làm cho vi phạm nên linux mất đi công cụ quản lí mã nguồn cốt lõi
git được thiết kế nhằm giải quyết vấn đề vì nó đáp ứng
-TỐC ĐỘ LÀ ƯU TIÊN : Git viết bằng C, tối ưu hóa phần cứng performance
-PHÂN TÁN          :Mỗi dev đều có bản sao của dự án có thể làm riêng
-Chuyển nhánh      :git có một nhánh chỉ là con trỏ 41byte tới một commit. Chuyển nhánh rất nhẹ và nhanh
-Bảo mật           :đảm bảo dữ liệu kh bao giờ bị hỏng và sửa đổi lén lút bị phát hiện





### 2
KHÁC BIỆT GIT VÀ GITHUB/GITLAB/BITBUCKET
Bản chất:Git là công cụ phần mềm quản lí phiên bản mã nguồn mở
        :Github là các dich vụ điện toán đám mây lưu trữ kho chứa git

Nơi hoạt động:Git được cài và chạy trực tiếp trên local của dev
             :github chạy trên máy chủ thông qua giao diện trình duyệt hoặc API


Chức năng chính:Git theo dõi lịch sử hay đổi file,tạo nhánh, khôi phục phiên bản cũ
               :github lưu trữ code online,chia sẻ code và làm việc nhóm, quản lí dự án phân quyền code review

Kết nối:Git hoặt động offline,kh cần internet
        :github cần có mạng để đẩy code lên hoặc kéo về

Giào diện:git tương tác chủ yêu qua terminal haowjc client  
        :github giao diện web dễ thao tác, quản lí issue, pull request

TÚM LẠI git là động cơ chiếc xe còn github là bãi đỗ xe hoặc gara



### 3
CÀI ĐẶT GIT VÀ CẤU HÌNH BÁN ĐẦU
git --version thì đã có là 2.54.0.windiws.1

Khi tạo một commit thì git sẽ gắn thông tin người làm vào commit đó.
Khi chạy lệnh git config --global user.name "Lê Tiến Dũng" giúp thiết lập tên hiện thị
Tương tự với email cũng vậy

Sử dụng SSH Key giúp xác thực an toàn và không cần phải nhập mật khẩu/token mỗi khi push hoặc pull code.
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH0PYQ7AXUrYo1xoWUuz7WTYoNjV8YtigR3/ghm+tC02 ledung85499@gmail.com
Đây là mã ssh key đã được tao
đã vào setting và ssh trên github và add được ssh key
lệnh ssh -t git@gihub.com thì đã chạy được 



### 4
git init: tạo một kho lưu trữ repo git mới hoàn toàn trong thư mục trống trên local tạo ra một thư mục ẩn .git
git clone url:sẽ sao chép một kho lưu trữ đã có sẵn về lap cá nhân bao gồm cả lịch sử commit và thư mục ẩn .git
Cấu trúc .git : sẽ chưa các metadata, lịch sử commit, thông tin branch, và config của repo chính



### 5
Trạng thái file trong git
Untracked: file mới được tạo vào mục dự án nhưng chưa được git quản lí và theo dõi
Staged   : file được đưa vào khu vực chuẩn bị bằng lệnh git add. chờ để lưu và commit tiếp theo 
Committed: file được lưu trữ an toàn và đi vào lịch sử của kho lưu trữ sau khi chạy lệnh git commit -m ""
Modified : file có săn trong lichj sử git nhưng vừa bị thay đổi ở máy tính so với bản kéo về máy gần nhất

các câu lệnh trạng thái
git status :kiểm tra trạng thái hiện tại của file trong thư mục xem nó hiện ra gì như stage modifed untracked
git diff   :xem chi tiết các dòng code cụ thể được thêm vào hay xóa đi so với phiên bản trước đây đại loại là so sánh xem khác nhau cái gì



### 6
các câu lệnh thực hiện
git add <tên file> :đưa các file thay đổi vào khu vực chuẩn bị(stageing arena) 
git commit -m "nội dung viết gì cũng được" : lưu các thay đổi từ stageing arena vào kho lưu trũ kèm thay lời nhắn cho dễ nhớ

Cách viết commit tốt
Sử dụng câu mệnh lệnh ngón gọn thì hiện tại như add fix update chứ kh dùng thì quá khứ 
dòng đầu tiên dưới 50 kí tụ ,tóm tắt mục đích thay đổi
Nếu cần, xuống dòng viết thêm chi tiết mô tả vì sao thay đổi 


### 7
Làm việc với lịch sử và phiên bản
git log   :liệt kê toàn bộ danh sách những lần commit trước đó như ai làm, thời gian nào,lời nhắn là gì(đại loại sổ nhât kỉ)
git show<id commit>: xem chi tiết một mốc thời gian cụ thể ở lần commit trước đó sửa dòng code nào

git blame<tên file>:hiển thị từng dòng code trong file do ai viết và commit lúc nào(đại loại dang tra cứu trách nhiệm xem ai làm sai)
commit id: là một chuỗi mã óa dài khoảng 40 kí tự độc nhất cho mỗi lần commit git dùng chuỗi nào là CCCD để nhận diện chính xác mốc thời gian 


### 8
UNDO
git checkout/ git restore:khi vừa sửa một file ở máy nhưng chưa đưa các file thay đổi vào một thư mục chuẩn bị.Lệnh này hủy bỏ các thay đổi và đưa file và sạch sẽ như chưa hề có cuộc chia li

git reset:xọa sạch lịch sử commit đã làm trước, quay ngược thời gian vứt bỏ các commit sau

git revert:tạo ra một bản vá ngược lại thay vì xóa sạch như reset giữ nguyên quá khứ đen tối và thêm một commit mới vô hiệu hóa lỗi commit trước


### 9
.gitinore : bỏ qua các dự án rác
Trong quá trình code, máy sẽ build ra nhiều file rác. File .gitinore sinh ra để cho lệnh git sẽ lờ đi coi như những file đó không tồn tại và chỉ quản lí những file cần được chăm sóc


### 10
Branch :nhánh chính là một bản sao độc lập của main chính tại một thời điềm. Cho phép tách ra làm việc riêng biêt mà kh ảnh hướng đến main 

Tại sao cần?
Giúp cho các dev cùng làm việc trên mà dự án mà kh dẫm chân lên nhau gây ra chồng chéo
Giúp thử nghiệm tính năng mới an toàn. Nếu viết lỗi chỉ cần xóa nhánh đó đi thôi mà kh sợ hệ thống sập 

### 11

git branch :dùng để xem danh sách các nhánh đang có hiện tại hoặc có thể tạo thêm một nhánh mới
git checkout -b <tên nhánh> vừa tạo nhánh mới và nhảy sang nó để làm việc luôn
Hoặc dùng lệnh xịn hơn là git switch -c <tên nhánh>
git checkout <tên nhánh>/git switch<tên nhánh>: nhảy qua nhảy lại giữa các nhánh


### 12 
merger và conflict
git merge <tên nhánh>: gộp toàn bộ code từ một nhánh khác vào nhánh hiện tại đang đứng
Xử lí xung đột (conflict):
                         xảy ra khi 2 nhánh cùng sửa vào chính xác một dong code có trong main được pull về nhưng lại viết 2 nội dung khác nhau. Git sẽ không biết gọi cái nào và tạo ra conflict yêu cầu dev tự ra quyết định chọn nhánh


### 13
chiến lược branch:
Là các quy tắc chuẩn khi làm việc nhóm để quản lí các nhánh cho khoa học
main/master: nhánh chính thức của dự án, luôn chứa code sachh, chạy hoàn hảo, và luôn sẵn sãng đưa lên môi trường thực tế cho user

develop :nhánh phát triển chung, nơi tổng hợp các tính năng mới trước khi đưa lên branch chính
feature/* :nhánh riêng do từng dev tự tạo ra để làm một công việc cụ thể như login, payment,..
hotfix/* :nhánh dùng để xử lí gấp các issure phát sinh khẩn cấp khi hệ thống đang chạy thực tế




### 14
git remote add <tên gọi> <url> :dung để khai báo cho máy tính biết đường dẫn đến kho chưa trên repo là origin chẳng hạn
git push :đẩy code từ máy tính lên trên repo
git pull :kéo code mới nhất từ repo về máy tính 
git fetch : giống git pull nhưng nó chỉ xem xét xem máy có gì mới và tải về máy âm thầm để xem trước chứ chưa tự động merge vào code hiện tại trên máy


### 15
fork : sao chép nền tảng cảu một dự án người khác về tài khoản của mình để có thể nắm quyền sở hữu và chỉnh sửa 
clone :tải kho đã fork đó từ trên github và máy cá nhân để bắt đầu code
pull request :code xong rồi thực hiện push lên repo, sẽ có một yêu cầu cần kéo để gửi bài đó sang repo riêng của dự án để nộp bài, nếu owner xem xét rồi mới accept code đại loại như đóng gói rồi nộp bài



### 16
Giải quyết conflict khi làm việc nhóm
Thực hành merge conflict thực tế :như nói bên trên thì khi nhiều người cùng sửa dòng code ở branch riêng của họ rồi push lên nhánh thì git kh biết nên lấy của ai bị conflict. Thì phải mở trực tiếp vsocde và chọn giữ lại đoạn code đúng của bạn và xóa của bạn khác kia đi rồi add và commit lại


### 17
Công cụ kĩ năng nâng cao
tag : thay vì nhớ các mã của commit như a1b2b3b34v4 quá khó tag để dán nhãn cho một mốc phiên bản cụ thể như v1.0.0

git tag <tên tag> :tạo nhãn cho phiên bản hiện tại
git describe      :giúp kiểm tra phiên bản hiện tại đang cách mốc tag gần nhất bao nhiêu commit




### 18
Stash(cất đồ tạm thời)
git stash :cất tạm code đang dang dở vào một package, giúp máy tính sạch sẽ và bạn sẽ làm việc khác, xong việc chỉ cần lấy ra dùng tiếp
Hoạt động như túi thần kì doraemon



### 19
Rebase và squash
Khi bạn làm việc và commit liên tục, lịch sử chi chít các dòng lệnh commit nháp liên tinh được dán nhãn
git rebase -i HEAD~n (n là số lượng commit muốn merge):mở ra trình chỉnh sửa để quản lí có thể merge hay squash
git rebase <tên nhánh chính>: giúp bốc toàn bộ commit mới ở nhánh của bạn cho thật đẹp đẽ rồi đem nộp vô nhánh chính



### 20
git allias log formatting
Thay vì phải gõ câu lệnh dài ngoặc nghèo như git status git remote add orgin ,... Bạn có thử tự tạo các phím tắt riêng (vd chữ st thay cho status hay ch thay checkout) để thao tác cực kì nhanh chóng



### 21
git reflog:khi bạn xóa nhầm nhánh hoặc reset hết commit. Lệnh này ghi lại hoặt động bạn tuwnhgf làm trên git . có thể tra cứu lại tọa độ cũ để phục hồi lại code



### 22
Dự án thực tế áp dụng git
merger confict: bạn và một người khác cùng sửa dòng code, rồi merge làm git bị rồi và kh biết chọn ai
-->mở file lên git sẽ đánh dấu rõ đoạn nào của bạn đoạn nào của người kia, bạn chọn code đúng xóa các kí hiệu thừa rồi add và commit lại

Revert code rollback version
 lỡ tay đẩy một đoạn code bị lỗi làm sập hệ thống 
---> dùng revert để tạo bản chuột bạch cho hệ thống xử tử

Dự án đã làm xong các tính năng của tuần này hoặc làm xong phiên bản này cần đóng gói và bàn giao
---> găn thẻ tag vào tạo bản release cho github để đánh dấu đã complete đến đâu rồi

Khi nào dùng fetch và pull
fetch: khi bản muốn kiểm tra xem trên gihub có ai vừa đẩy code mới lên không thật âm thầm, chưa muốn merge vào máy
pull :khi bản muốn tai thẳng code mới nhất trên repo về tự merge thẳng vô máy để làm việc tiếp 




