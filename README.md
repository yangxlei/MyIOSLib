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
                            callback:(apiRequestFinishCallback)callback Get 方式请求 API</li>
      <li>- (NSInteger)requestAPIWithPost:(NSString *)api
                             postBody:(NSDictionary *)postBody
                                                    callback:(apiRequestFinishCallback)callback Post 方式请求 API</li>
      <li></li>
      <li></li>
    </ol>
  
  </p>
