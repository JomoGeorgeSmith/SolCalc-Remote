//
//  SolarUtilities.swift
//  SolCalc
//
//  Created by Jomo Smith on 2/9/22.
//

import Foundation

public class SolarUtilities {


    
    enum Parish: String, CaseIterable, Identifiable {
    
    case Kingston,SaintThomas, Portland, StMary, StCatherine, StAnn, Manchester, Clarendon, Westmorland, StJames, StElizabeth,Hanover
    var id: Self { self }
        
        
}
    
    enum NumberOfDaysInWeek: Int, CaseIterable, Identifiable {
        
    //case One,Two,Three,Four,Five,Six,Seven
        case One=1,Two,Three,Four,Five,Six,Seven
        
    var id: Self { self }
}
    

}
