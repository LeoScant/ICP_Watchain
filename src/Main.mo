import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import List "mo:base/List";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Bool "mo:base/Bool";
import Principal "mo:base/Principal";
import Types "./Types";

shared({ caller }) actor class WatchainCertificate() = Self {
  stable var owner = caller;
  stable var transactionId: Types.TransactionId = 0;
  stable var nftCertificates = List.nil<Types.Nft>();

  // https://forum.dfinity.org/t/is-there-any-address-0-equivalent-at-dfinity-motoko/5445/3
  let null_address : Principal = Principal.fromText("aaaaa-aa");

  public query func balanceOfCertificates(user: Principal) : async Nat64 {
    return Nat64.fromNat(
      List.size(
        List.filter(nftCertificates, func(token: Types.Nft) : Bool { token.owner == user })
      )
    );
  };

  public query func ownerOfSmartContract() : async Principal {
    return owner;
  };

  public query({ caller }) func whoAmI() : async Principal {
    return caller;
  };

  public query func ownerOfCertificate(token_id: Types.TokenId) : async Types.OwnerResult {
    let item = List.find(nftCertificates, func(token: Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case (null) {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        return #Ok(token.owner);
      };
    };
  };

  public shared({ caller }) func safeTransferCertificate(from: Principal, to: Principal, token_id: Types.TokenId) : async Types.TxReceipt {  
    if (owner != caller) {
      return #Err(#Unauthorized);
    };
    if (to == null_address) {
      return #Err(#ZeroAddress);
    } else {
      return transferFrom(from, to, token_id, caller);
    };
  };

  public shared({ caller }) func transferCertificate(from: Principal, to: Principal, token_id: Types.TokenId) : async Types.TxReceipt {
    if (owner != caller) {
      return #Err(#Unauthorized);
    };
    return transferFrom(from, to, token_id, caller);
  };

  func transferFrom(from: Principal, to: Principal, token_id: Types.TokenId, caller: Principal) : Types.TxReceipt {
    let item = List.find(nftCertificates, func(token: Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case null {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        if (caller != token.owner and owner != caller) {
          return #Err(#Unauthorized);
        } else if (Principal.notEqual(from, token.owner)) {
          return #Err(#Other);
        } else {
          nftCertificates := List.map(nftCertificates, func (item : Types.Nft) : Types.Nft {
            if (item.id == token.id) {
              let update : Types.Nft = {
                owner = to;
                id = item.id;
                certificate = token.certificate;
              };
              return update;
            } else {
              return item;
            };
          });
          transactionId += 1;
          return #Ok(transactionId);   
        };
      };
    };
  };

  public query func totalMintedCertificates() : async Nat64 {
    return Nat64.fromNat(
      List.size(nftCertificates)
    );
  };

  public query func getCertificateFromTokenId(token_id: Types.TokenId) : async Types.MetadataResult {
    let item = List.find(nftCertificates, func(token: Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case null {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        return #Ok(token.certificate);
      }
    };
  };

  public query func getTokenIdsForUser(user: Principal) : async [Types.TokenId] {
    let items = List.filter(nftCertificates, func(token: Types.Nft) : Bool { token.owner == user });
    let tokenIds = List.map(items, func (item : Types.Nft) : Types.TokenId { item.id });
    return List.toArray(tokenIds);
  };

  public shared({ caller }) func mintCertificate(to: Principal, certificate: Types.WatchCertificate) : async Types.MintReceipt {
    if (owner != caller) {
      return #Err(#Unauthorized);
    };
    let newId = Nat64.fromNat(List.size(nftCertificates));
    let newCertificate : Types.Nft = {
      owner = to;
      id = newId;
      certificate = certificate;
    };
    nftCertificates := List.push(newCertificate, nftCertificates);
    transactionId += 1;
    return #Ok({
      token_id = newId;
      id = transactionId;
    });
  };

  public shared({ caller }) func updateCertificate(token_id: Types.TokenId, token_owner: Principal, certificate: Types.WatchCertificate) : async Types.TxReceipt {
    let item = List.find(nftCertificates, func(token: Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case null {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        if (caller != token.owner and owner != caller) {
          return #Err(#Unauthorized);
        } else if (Principal.notEqual(token_owner, token.owner)) {
          return #Err(#Other);
        } else {
          nftCertificates := List.map(nftCertificates, func (item : Types.Nft) : Types.Nft {
            if (item.id == token.id) {
              let update : Types.Nft = {
                owner = item.owner;
                id = item.id;
                certificate = certificate;
              };
              return update;
            } else {
              return item;
            };
          });
          transactionId += 1;
          return #Ok(transactionId);   
        };
      };
    }; 
  };

  public shared({ caller }) func burnCertificate(token_id: Types.TokenId, token_owner: Principal) : async Types.TxReceipt {
    let item = List.find(nftCertificates, func(token: Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case null {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        if (caller != token.owner and owner != caller) {
          return #Err(#Unauthorized);
        } else if (Principal.notEqual(token_owner, token.owner)) {
          return #Err(#Other);
        } else {
          nftCertificates := List.filter(nftCertificates, func(token: Types.Nft) : Bool { token.id != token_id });
        };
        transactionId += 1;
        return #Ok(transactionId);   
      }
    }
  };

}