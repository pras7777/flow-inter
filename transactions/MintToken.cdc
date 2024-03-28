import FungibleToken from 0x05
import Token from 0x05

transaction(amountToMint: UFix64) {
    let minter: &Token.Minter
    let signer: AuthAccount

    prepare(signerRef: AuthAccount) {
        self.signer = signerRef
        self.minter = self.signer.borrow<&Token.Minter>(from: /storage/FlowMinter)
            ?? panic("Minter resource not found")
    }

    execute {
        let newTokens <- self.minter.mintTokens(amount: amountToMint)
       self.signer.save(<-newTokens, to: /storage/FlowVault)
        log("Minted ${amountToMint} FlowTokens successfully")
    }
}