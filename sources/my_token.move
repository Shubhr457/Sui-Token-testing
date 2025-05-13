module my_token::my_token {
    use sui::event;
    use sui::object::{Self, ID};
 
    /// The type identifier of our coin
    public struct MY_TOKEN has drop {}

    public struct TreasuryCreated has copy,drop{
        treasuryID:ID,
    }

    /// Module initializer is called once on module publish
    fun init(witness: MY_TOKEN, ctx: &mut sui::tx_context::TxContext) {
        let (treasury, metadata) = sui::coin::create_currency(
            witness, 6, b"BITCOIN", b"BTC", b"Bitcoin", std::option::none(), ctx
        );

        event:: emit(TreasuryCreated{treasuryID:object::id(&treasury)});
        sui::transfer::public_freeze_object(metadata);
        sui::transfer::public_transfer(treasury, sui::tx_context::sender(ctx))
    }

    /// Mint new MY_TOKEN coins and transfer to the transaction sender
    public entry fun mint(
        treasury_cap: &mut sui::coin::TreasuryCap<MY_TOKEN>,
        amount: u64,
        ctx: &mut sui::tx_context::TxContext
    ) {
        let coin = sui::coin::mint(treasury_cap, amount, ctx);
        sui::transfer::public_transfer(coin, sui::tx_context::sender(ctx));
    }
    
    /// Mint and transfer tokens to a specified recipient
    public entry fun mint_and_transfer(
        treasury_cap: &mut sui::coin::TreasuryCap<MY_TOKEN>,
        amount: u64,
        recipient: address,
        ctx: &mut sui::tx_context::TxContext
    ) {
        let coin = sui::coin::mint(treasury_cap, amount, ctx);
        sui::transfer::public_transfer(coin, recipient);
    }
}
