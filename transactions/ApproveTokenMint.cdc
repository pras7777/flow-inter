import FungibleToken from 0x05
import Token from 0x05

transaction (_allowedAmount: UFix64){
    let admin: &Token.Administrator
    let signer: AuthAccount
    prepare(signerRef: AuthAccount) {
        self.signer = signerRef
        self.admin = self.signer.borrow<&Token.Administrator>(from: /storage/newflowTokenAdmin)
            ?? panic("You are not the admin")
    }
    execute {
        let newMinter <- self.admin.createNewMinter(allowedAmount: _allowedAmount)
        self.signer.save(<-newMinter, to: /storage/FlowMinter)
        log("Flow minter created successfully")
    }
}