//
//  HeadlineModels.swift
//  News
//
//  Created by zs-mac-6 on 07/11/22.
//

import Foundation


struct HeadlineModel{
    
//    3dc998f91be9441cb67dd4d93d0fc001
//    4b6dfa1f042840a49b334423f1bcc73f
    struct FetchResponse{
        static let apiKey="4b6dfa1f042840a49b334423f1bcc73f"
        
        
        
        static let countriesNamesAndCode:[String:String]=["United Arab Emirates":"ae","Argentina":"ar","Austria":"at","Australia":"au","Belgium":"be","Bulgaria":"bg","Brazil":"br","Canada":"ca","Switzerland":"ch","China":"cn","Colombia":"co","Cuba":"cu","Czechia":"cz","Germany":"de","Egypt":"eg","France":"fr","United Kingdom":"gb","Greece":"gr","Hong Kong":"hk","Hungary":"hu","Indonesia":"id","Ireland":"ie","Israel":"il","India":"in","Italy":"it","Japan":"jp","South Korea":"kr","Lithuania":"lt","Latvia":"lv","Morocco":"ma","Mexico":"mx","Malaysia":"my","Nigeria":"ng","Netherlands":"nl","Norway":"no","New Zealand":"nz","Philippines":"ph","Poland":"pl","Portugal":"pt","Romania":"ro","Serbia":"rs","Russia":"ru","Saudi Arabi":"sa","Sweden":"se","Singapore":"sg","Slovenia":"si","Slovakia":"sk","Thailand":"th","Turkey":"tr","Taiwan":"tw","Ukraine":"ua","United States":"us","Venezuela":"ve","South Africa":"za"]
        
        
        struct HeadlineData{
            var data:Data!
        }
        
    }
    
    struct ViewModel:Decodable{
        var articles:[Articles]
        struct Articles:Decodable{
            var title:String?
            var description:String?
            var url:String?
            var urlToImage:String?
        }
      
    }
    
    struct countryDetails:Decodable{
        
        var name:String?
        var cca2:String?
    }
    
    
    
}
