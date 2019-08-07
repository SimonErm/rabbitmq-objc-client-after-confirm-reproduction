import Foundation
import CleanroomLogger
@objc
public class Reproducable:NSObject{
  
  @objc
  public func runExample (){
    let connection = RMQConnection(uri: self.getUri(), delegate: RMQConnectionDelegateLogger(), delegateQueue: DispatchQueue.global());
    connection.start();
    let channel = connection.createChannel()
    let props=[RMQBasicContentType("application/octet-stream"),
               RMQBasicContentEncoding("UTF-8"),
               RMQBasicDeliveryMode(1),
    ];
    
    channel.confirmSelect();
    channel.afterConfirmed{ (acked, nacked) in
      print("confirmed:",acked.count,nacked.count)
    }
    
    
    channel.basicPublish("test_message".data(using: .utf8)!, routingKey: "test", exchange: "", properties: props, options: RMQBasicPublishOptions(rawValue: 0));
    
    
  }
  private func getUri()->String{
    var amqpUri = "amqps://";
    amqpUri.append("guest");
    amqpUri.append(":");
    amqpUri.append("guest".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPasswordAllowed)!);
    amqpUri.append("@");
    amqpUri.append("localhost".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!);
    amqpUri.append(":");
    amqpUri.append(String(5672));
    amqpUri.append("/");
    amqpUri.append("test");
    return amqpUri;
  }
  
}
