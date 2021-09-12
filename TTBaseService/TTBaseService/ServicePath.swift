//
//  ServicePath.swift
//  TTBaseService
//
//  Created by Remzi YILDIRIM on 13.02.2020.
//  Copyright © 2020 Turkish Technic. All rights reserved.
//

import Foundation
import TTBaseModel

public enum ServicePath: String, CustomStringConvertible {
    
    case login = "/login"
    case permission = "/userperms"
    case checkAppVersion = "/application/AppVersioncheck"
    case userAuthControl = "/Account/UserAuthControl"
    case getUserProfilePhoto = "/EmployeeInfo/GetUserImage"
    case getDailyandTransitCheckList, rejectChecksandItems, startChecksandItems, resumeStopPauseChecksandItems = "/roster/get"
    case userImage = "/user/getPhoto"
    case acUnitMaster
    case getAllFlightList = "/acmaster/get"
    case getAcUnitType = "/AcUnitType/get"
    case lastActualFlight = "/LastAcActualFlight/get"
    case getAcUnitTypeTransaction = "/AcUnitTypeTransaction/get"
    case setAcUnitTypeTransaction = "/AcUnitTypeTransaction/Set"
    case getFleet = "/Fleet/get"
//    case getFlightArrival = "/FlightArrival/get"
//    case getFlightDeparture = "/FlightDeparture/get"
    case getFlightSchedule = "/flightschedule/list"
    case getDepartment = "/roster/getDepartment"
    case getSlot = "/roster/getSlot"
    case getFlightList = "/Aircraft/get"
    case createOrStartSelfAssigned = "/roster/createOrStartSelfAssigned"
    case getLocationList = "/LocationMaster/get"
    case getChapter = "/ChapterSection/getchapter"
    case getSection = "/ChapterSection/getSection"
    case getSkill = "/TranCode/getSkill"
    case checkEmployee = "/Employee/getcheckEmployee"
    case tranCode = "/TranCode/get"
    case getDefectReport = "/DefectReport/GetDefectReport"
    case getDefectReportsByAc = "/DefectReport/GetDefectReportsByAc"
    case getAcRosterDocPath = "/AcMaster/GetAcRosterDocPath"
    case getCdrmLocation = "/CabinCdrm/GetCdrmLocation"
    case getCdrmPart = "/CabinCdrm/GetCdrmPart"
    case getCdrmPartDesc = "/CabinCdrm/GetCdrmPartDesc"
    case getCdrm = "/CabinCdrm/GetCdrm"
    case getCdrmWhere = "/CabinCdrm/GetCdrmWhere"
    case setDefect = "/DefectReport/SetDefect"
    case getWorkOrders = "/Wo/GetWorkOrders"
    case getWoTaskCards = "/WoTaskCard/GetWorkOrderTaskCards"
    case getWAList = "/WoTaskCardAccomplished/GetWoTaskCardWorkAccomplished"
    case addWA = "/WoTaskCardAccomplished/AddWoTaskCardWorkAccomplished"
    case removeWA = "/WoTaskCardAccomplished/RemoveWoTaskCardWorkAccomplished"
    case updateWA = "/WoTaskCardAccomplished/UpdateWoTaskCardWorkAccomplished"
    case addNRTC = "/WoTaskCard/AddNrtc"
    case updateNRTC = "/WoTaskCard/UpdateNrtc"
    case closeNRTC = "/WoTaskCard/CloseNrtc"
    case manhourGetSkill = "/ManHour/GetSkills"
    case manhourGetList = "/WoActual/Get"
    case manhourUpdate = "/WoActual/Update"
    case manhourAdd = "/WoActual/Add"
    case manhourDelete = "/WoActual/Delete"
    case getAcActualFlights = "/AcUnitType/GetAcActualFlights"
    case addOrUpdateDeviceToken = "/Application/AddOrUpdateDeviceToken"
    case getDefectReportsArchive = "/DefectReport/GetDefectReportsArchive"
    case closeDefect = "/DefectReport/CloseDefect"
    case deferDefect = "/DefectReport/DeferDefect"
    case getDefectReportPn = "/DefectReportPn/GetDefectReportPn"
    case addOrUpdateDefectPnRequirement = "/DefectReportPn/AddOrUpdateDefectPnRequirement"
    case removeDefectreportPn = "/DefectReportPn/RemoveDefectreportPn"
    case getDefectReportTroubleShooting = "/DefectReportTroubleShooting/GetDefectReportTroubleShooting"
    case addOrUpdateDefectTroubleShooting = "/DefectReportTroubleShooting/AddOrUpdateDefectTroubleShooting"
    case removeDefectreportTroubleShooting = "/DefectReportTroubleShooting/RemoveDefectreportTroubleShooting"
    case getDefectMels = "/DefectMels/GetDefectMels"
    case getCabinDefectCategoryConfig = "/CabinCdrm/GetCabinDefectCategoryConfig"
    case pnMaster = "/inventory/pn/info"
    case inventoryDetails = "/inventory/pn/details"
    case inventorySummaries = "/inventory/pn/sumbylocation"
    case inventoryControls = "/inventory/pn/controlandcycles"
    case getMeetAndGreetControlList = "/meetgreet/controllist"
    case updateMeetAndGreetGroupStatus = "/meetgreet/update/groupstatus"
    case addOrUpdateMeetAndGreet = "/meetgreet/add/list"
    case createTicket = "/defect/ticket/add"
    case scheduleTC = "/taskcard/list"
    case updateTicket = "/defect/ticket/update"
    case getTicketList = "/defect/ticket/list" //MNM
    case addCabinDefect = "/defect/add"
    case addCabinDefectList = "/defect/add/list"
    case getCabinDefectList = "/defect/list" //MNM
    case updateCabinDefect = "/defect/update"
    case updateCabinDefectList = "/defect/update/list"
    case deleteCabinDefect = "/defect/delete"
    case cabinGetManhourList = "/defect/manhour/list"
    case cabinAddManhour = "/defect/manhour/add"
    case cabinDeleteManhour = "/defect/manhour/delete"
    case cabinDBsync = "/defect/dbsync"
    case cabinGetAllFlightList = "/lopa/aclist"
    case lopaInfo = "/lopa/info"
    case dtsTaskcardList = "/taskcard/dts/list"
    case dtsTaskcardStamp = "/dts/stamp"
    case dtsTaskcardStamps = "/dts/stamps"
    case dtsSmsCodeCreate = "/dts/smscode/create"
    case dtsSmsCodeVerify = "/dts/smscode/verify"
    case dtsCreatePdf = "/dts/pdf"
    case dtsWoStampCounts = "/dts/wostampcounts"
    case dtsArchive = "/dts/archive"
    case dtsCustomerWO = "/dts/customerwolist"
    case dtsPDFControl = "/dts/pdfcontentcontrol"
    case dtsPDFEmail = "/dts/pdfemail"
    case getWorkOrderList = "/wo/list"
    
    case epcTableInfo = "/epc/table/info"
    case epcCabinCMM = "/epc/cabin/cmm"
    case epcFigureMatch = "/epc/table/figurematch"
    case epcPnImage = "/epc/pn/image"
    
    case nrcWorkArea = "/taskcard/systemtrancode/list"


    public var isCore: Bool {
        switch self {
        case .login, .permission, .pnMaster, .inventoryDetails, .inventorySummaries, .inventoryControls, .getMeetAndGreetControlList, .updateMeetAndGreetGroupStatus, .addOrUpdateMeetAndGreet, .createTicket, .updateTicket, .addCabinDefectList, .getCabinDefectList, .updateCabinDefectList, .deleteCabinDefect, .cabinGetManhourList, .cabinAddManhour, .cabinDeleteManhour, .lopaInfo, .cabinDBsync, .updateCabinDefect, .cabinGetAllFlightList, .getTicketList, .scheduleTC, .dtsTaskcardList, .dtsTaskcardStamp, .dtsSmsCodeCreate, .dtsCreatePdf, .dtsSmsCodeVerify, .dtsTaskcardStamps, .dtsWoStampCounts, .dtsArchive, .getWorkOrderList, .dtsCustomerWO, .dtsPDFControl, .dtsPDFEmail, .getFlightSchedule, .epcTableInfo, .epcCabinCMM, .epcFigureMatch, .epcPnImage, .nrcWorkArea:
            return true
        default:
            return false
        }
    }

    public var description: String {
        get {
            var value = self.rawValue
            
            switch self.rawValue {
            case "getDailyandTransitCheckList": value = "/roster/get"
            case "rejectChecksandItems": value = "/roster/get"
            case "startChecksandItems": value = "/roster/get"
            case "resumeStopPauseChecksandItems": value = "/roster/get"
            case "acUnitMaster": value = "/acmaster/get"
            default: break
            }
            
            return QueryConstant.apiBaseUrl(isCore: isCore, withPath: value)
        }
    }
}
