header('X-Accel-Buffering: no');
header('Content-Type: text/event-stream');
header('Cache-Control: no-cache');
ob_end_clean();
ob_implicit_flush(1);

while(1){

    $data =  [
        "id" => time(),
        "message" => '欢迎来到helloweba，现在是北京时间'.date('Y-m-d H:i:s')
    ];
    <!-- 每隔10秒向客户端输出一条数据 -->
    returnEventData($data);
    sleep(10);
}

function returnEventData($returnData, $event='message', $id=0, $retry=0){

    $str = '';
    if($id>0){
        $str .= "id: {$id}".PHP_EOL;
    }
    if($event){
        $str.= "event: {$event}".PHP_EOL;
    }
    if($retry>0){
        $str .= "retry: {$retry}".PHP_EOL;
    }
    if(is_array($returnData)){
        $returnData = json_encode($returnData);
    }
    $str .= "data: {$returnData}".PHP_EOL;
    $str .= PHP_EOL;
    echo $str;
}