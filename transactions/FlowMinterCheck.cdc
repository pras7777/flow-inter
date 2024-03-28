import FungibleToken from 0x05
import Token from 0x05

transaction() {
  let flowMinter: &Token.Minter

  prepare(acct: AuthAccount) {
    self.flowMinter = acct.borrow<&Token.Minter>(from: /storage/FlowMinter)
        ?? panic("FlowToken Minter is not present")
    log("FlowToken Minter is present")
  }
  execute {
    // No execution logic needed in this case
  }
}