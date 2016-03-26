# SOA Assignment

##部署方法

1. 安装RVM
    ```
    $ #!bin/sh
    $ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    $ curl -sSL https://get.rvm.io | bash -s stable
    or visit [rvm.io](http://rvm.io)
    ```
2. 安装Ruby
    ```
    $ #!/bin/sh
    $ bash -l
    $ rvm install 2.3.0
    $ rvm use 2.3.0
    $ ruby -v
    ```
3. 安装Rack
    ```
    $ gem install rack
    ```
4. 修改一些配置
    ```
    在view.html中把回调页面的127.0.0.1:9292换成域名
    在config.ru中把回调页面的127.0.0.1:9292换成域名
    登录http://open.weibo.com,选择"管理中心"->"我的应用"->[您的应用名]->展开左侧"应用信息"->"高级信息"->"OAuth2.0 授权设置"->右上角"编辑"->在框里填入[域名]/redirect
    ```
5. 运行服务器
    ```
    $ rackup config.ru
    ```