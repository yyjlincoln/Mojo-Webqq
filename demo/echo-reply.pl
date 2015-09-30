use lib "../";
use Mojo::Webqq;
use Mojo::Util qw(md5_sum);

#注意: 
#程序内部数据全部使用UTF8编码，因此二次开发源代码也请尽量使用UTF8编码进行编写，否则需要自己做编码处理
#在终端上执行程序，会自动检查终端的编码进行转换，以防止乱码
#如果在某些IDE的控制台中查看执行结果，程序无法自动检测输出编码，可能会出现乱码，可以手动设置输出编码
#手动设置输出编码参考文档中关于 log_encoding 的说明

#帐号可能进入保护模式的原因:
#多次发言中包含网址
#短时间内多次发言中包含敏感词汇
#短时间多次发送相同内容
#频繁异地登陆

#推荐手机安装[QQ安全中心]APP，方便随时掌握自己帐号的情况

my $qq = 12345678;
my $pwd = "your password";   #使用帐号密码方式登录时需要
my $pwd_md5 = md5_sum($pwd); #得到原始密码的32位长度md5

#初始化一个客户端对象，设置登录的qq号
my $client=Mojo::Webqq->new(
    ua_debug    =>  0,         #是否打印详细的debug信息
    qq          =>  $qq,       #登录的qq帐号
    pwd         =>  $pwd_md5,  #可选，如果选择帐号密码登录方式，必须指定帐号密码的md5值
    login_type  =>  "qrlogin", #"qrlogin"表示二维码登录，"login"表示帐号密码登录
);
#注意: 腾讯可能已经关闭了帐号密码的登录方式，这种情况下只能使用二维码扫描登录

#客户端进行登录
$client->login();

#客户端加载ShowMsg插件，用于打印发送和接收的消息到终端
$client->load("ShowMsg");

#ready事件触发时表示客户端一切准备就绪，建议尽量将自己的代码写在ready内
$client->on(ready=>sub{
    #设置接收消息事件的回调函数，在回调函数中对消息以相同内容进行回复
    $client->on(receive_message=>sub{
        my ($client,$msg)=@_;
        #已以相同内容回复接收到的消息
        $client->reply_message($msg,$msg->content);
        #你也可以使用$msg->dump() 来打印消息结构
    });
});

#客户端开始运行
$client->run();
