
class JavaScripeUtil {
  // JavaScripeUtil();

   static String generateFunction({
     required String functionName,
     required String handlerName,
   }){

    return """
    async function $functionName(input){
      return await window.flutter_inappwebview.callHandler('$handlerName', input) 
    }
    """;
  }

  static String send({
    required String functionName,
    required dynamic input,
  }) {
     return """
     $functionName("$input")
     """;
  }
}