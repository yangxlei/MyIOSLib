MyIOSLib:
  整理自己 iOS 类库:<br/>
  实现 Data， 网络，数据，图片等一系列功能的整合

  各类功能及调用说明:<br/>
  
  <p>JsonUtils:</p>
  <p>封装关于 Json 的所有操作。应用内所有涉及到 Json 的操作都必须调用其中的方法。所有涉及到 Dictionary，Array 的操作，都会自动转换为 NSMutableXXX;
  涉及到基础类型的保存和取值也调用相应的方法</p>

  <br/>
  <p>APIManager:</p>
  <p>处理网络请求的工具类, 默认并发请求为 5 个，超过 5 个其他的请求都会转为等待状态。对外调用不需要关心这个。<br/> 
    各个方法：
    <ol>
      <li>- (NSInteger)requestAPIWithGet:(NSString *)api
                            callback:(apiRequestFinishCallback)callback       Get 方式请求 API</li>
      <li>- (NSInteger)requestAPIWithPost:(NSString *)api
                             postBody:(NSDictionary *)postBody
                           callback:(apiRequestFinishCallback)callback     Post 方式请求 API</li>
      <li>- (NSInteger)requestDownloadFile:(NSString *)api
                      progressCallback:(apiRequestProgressCallback)progress
                           finishCallback:(apiRequestFinishCallback)callback         请求下载文件</li>
      <li>- (NSInteger)requestUploadFile:(NSString *)api
                            postBody:(NSDictionary *)postBody
                            file:(NSDictionary *)file
                           progressCallback:(apiRequestProgressCallback)progress
                           finishCallback:(apiRequestFinishCallback)callback   请求上传文件</li>
      <li>- (void)cancelRequest:(NSInteger)taskId   取消正在处理的请求任务</li>                  
    </ol>
   <p>返回的回调 block 中会有 HTTPResult 对象。其中 code 表示此次请求处理的返回码，等于 SUCCESSFULL 表示正常处理成功。 data 为处理完成返回的数据</p>
   <B>PS: requestXXX 方法会返回当前处理任务的 ID。所以在界面正常退出(如:viewDidDisAppear， dealloc)的地方，应该主动 cancelRequest 这次任务, 清除回收对应的资源</B>

  </p>
  <br/>
  <p>BJUserAccount:</p>
  <p>用户账户， 在 APP 内部会模拟两个账户, 一个匿名 anonymous 账户，一个用户登录后使用的 main 账户. 两个账户底下会有各自的 authToken；在 APIManager 请求网络时，如果已经登录， 会使用 main account，如果没有登录，使用 anonymous account; 上层在正常请求时，不需要关心"我"当前是否已经登录了. <br/>
  Common 工具类是个单例，从中获取 anonymous 和 main account 的实例 
  </p>


  <p>BJData:</p>
  <p>所有数据模型的基类</p>



