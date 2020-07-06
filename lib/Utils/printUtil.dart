class PrintUtil{
  static bool isDebug = true;// 是否需要打印bug，可以在application的onCreate函数里面初始化
  static final String TAG = "way";
  static void e(String msg)
  {
    if (isDebug)
//      Log.e(TAG, msg);
    print(msg);
  }
  /**
   * 分段打印出较长log文本
   * @param logContent  打印文本
   * @param showLength  规定每段显示的长度（AndroidStudio控制台打印log的最大信息量大小为4k）
   * @param tag         打印log的标记
   */
  static void showLargeLog(String logContent, int showLength){
    if(logContent.length > showLength){
      String show = logContent.substring(0, showLength);
//      e(tag, show);
      print(show);
      /*剩余的字符串如果大于规定显示的长度，截取剩余字符串进行递归，否则打印结果*/
      if((logContent.length - showLength) > showLength){
        String partLog = logContent.substring(showLength,logContent.length);
        showLargeLog(partLog, showLength);
      }else{
        String printLog = logContent.substring(showLength, logContent.length);
//        e(tag, printLog);
      print(printLog);
      }

    }else{
//      e(tag, logContent);
    print(logContent);
    }
  }

}