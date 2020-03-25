# MyCreditChain-Klaytn

MyCreditChain(MCC) is a blockchain platform of personal credit information. This project aims to bring the ownership of credit information back to individuals. MCC revolutionizes the all process of how personal credit information is gathered and used. Moreover, MCC can further revolutionize our interaction with one another in one global network.

* Changes
1. The Ethereum based token(https://github.com/mccdeveloper/MyCreditChain)has been replaced with the Klaytn based token.
- Klaytn reference: https://docs.klaytn.com/smart-contract/token-standard
- token information reference: https://scope.klaytn.com/
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;https://wallet.klaytn.com/

2. Seed Publishing(Seed Transaction) feature has been added.
3. The latest OpenZeppelin library has been applied.
4. Token optimization was performed by removing unnecessary features.

# Smart Contract


- ## MCCToken
    - MCCToken is based on ERC20 standard.
    - To prevent overflow with arithmetic operations, MCCToken uses SafeMath library
    - Blocking token transfer that locks MCC token of specific token owener is added to prevent unfortunate accident like hacking
    - MCCToken defines the token standard will be used for MCC service

    - Public Variables:

        1. **name**     - token name   (ERC20 option)
        2. **symbol**   - token symbol (ERC20 option)
        3. **decimals** - number of digits the cryptocurrency has after the decimal point (ERC20 option)

# Future Plans

The services provided by MyCreditChain can be summarized as follows.

- The B2P credit information transaction is expected to be the most active within the MCC network. MyCreditChain provides a platform for individuals and companies to make direct transaction of information.

- In the MCC network, individuals can start a P2P financing business. Its platform can be used to make and exchange contracts for private transactions between individuals. With mutual consents, each party can look through other party’s credit information to identify reliability.
