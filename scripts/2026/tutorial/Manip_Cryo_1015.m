root = 'http://133.11.161.88:47101/v1';

%%
% PUTリクエストタイプを使用するためのオプションを設定します
options = weboptions( 'RequestMethod' , 'put' );

% 送信するデータを280Kに設定し、それをターゲットとする
data = struct ( 'platformTargetTemperature' , 280);

% リクエストを送信
reply = webwrite([root '/controller/properties/platformTargetTemperature' ], data, options);

% PUTリクエストタイプを使用するためのオプションを設定します
options = weboptions( 'RequestMethod' , 'post' );

% リクエストを送信
reply = webwrite([root '/controller/methods/cooldown()' ], options);