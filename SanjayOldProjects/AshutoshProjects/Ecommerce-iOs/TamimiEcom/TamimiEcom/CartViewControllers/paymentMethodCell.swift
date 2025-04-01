//
//  CheckOutGridCell.swift
//  TamimiEcom
//
//  Created by Ansh on 10/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
protocol PaymentsMethodType:class {
    func selectPaymentsOption(indx:Int)
    func isGiftCardSelect(isSlect:Bool)
    func iseWalletSelect(isSlect:Bool)
    
}
class paymentMethodCell: UICollectionViewCell {
    weak var delegate:PaymentsMethodType?
    var paymenttSlectionType = 0
    var giftCardSelect = false
    var eWalletSelect = false

    @IBOutlet weak var lblAmmount: UILabel!
    @IBOutlet weak var lblAmountHint: UILabel!
    
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnUseWallet: UIButton!
    @IBOutlet weak var txtFieldGiftCard: UITextField!
    @IBOutlet weak var btnGiftCard: UIButton!
    @IBOutlet weak var btnDebitCard: UIButton!
    @IBOutlet weak var btnCreditCard: UIButton!
    @IBOutlet weak var btnCashOnDeliver: UIButton!
    @IBOutlet weak var btnClearAll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updatePayemtType() {
        btnDebitCard.isSelected = self.paymenttSlectionType == 0 ? true : false
        btnCreditCard.isSelected = self.paymenttSlectionType == 1 ? true : false
        btnCashOnDeliver.isSelected = self.paymenttSlectionType == 2 ? true : false
        btnGiftCard.isSelected = giftCardSelect
        btnUseWallet.isSelected = eWalletSelect
    }
    @IBAction func debitCardAction(_ sender: Any) {
        self.paymenttSlectionType = 0
        self.updatePayemtType()
        self.delegate?.selectPaymentsOption(indx: self.paymenttSlectionType)
    }
    @IBAction func credtCardAction(_ sender: Any) {
        self.paymenttSlectionType = 1
        self.updatePayemtType()
        self.delegate?.selectPaymentsOption(indx: self.paymenttSlectionType)

    }
    @IBAction func cashOnDeliveryAction(_ sender: Any) {
        self.paymenttSlectionType = 2
        self.updatePayemtType()
        self.delegate?.selectPaymentsOption(indx: self.paymenttSlectionType)
    }
    
    @IBAction func clearAllAction(_ sender: Any) {
        txtFieldGiftCard.text = ""
        self.paymenttSlectionType = 0
        self.giftCardSelect = false
        self.eWalletSelect = false
        self.delegate?.selectPaymentsOption(indx: self.paymenttSlectionType)
        self.delegate?.isGiftCardSelect(isSlect: self.giftCardSelect)
        self.delegate?.iseWalletSelect(isSlect: self.eWalletSelect)
        self.updatePayemtType()

    }
    
    @IBAction func giftCardAction(_ sender: Any) {
        self.giftCardSelect = !self.giftCardSelect
        self.delegate?.isGiftCardSelect(isSlect: self.giftCardSelect)
        self.updatePayemtType()

    }
    @IBAction func eWalletAction(_ sender: Any) {
        self.eWalletSelect = !self.eWalletSelect
        self.delegate?.iseWalletSelect(isSlect: self.eWalletSelect)
        self.updatePayemtType()
    }
    
    @IBAction func applyAction(_ sender: Any) {
        
    }
}
