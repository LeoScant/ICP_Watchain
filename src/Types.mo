import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";

module {

  public type ApiError = {
    #Unauthorized;
    #InvalidTokenId;
    #ZeroAddress;
    #Other;
  };

  public type Result<S, E> = {
    #Ok : S;
    #Err : E;
  };

  public type OwnerResult = Result<Principal, ApiError>;
  public type TxReceipt = Result<Nat, ApiError>;
  
  public type TransactionId = Nat;
  public type TokenId = Nat64;

  public type NaterfaceId = {
    #Approval;
    #TransactionHistory;
    #MNat;
    #Burn;
    #TransferNotification;
  };

  public type Picture = {
    picture_type: Text;
    data: Text;
  };

  public type Nft = {
    owner: Principal;
    id: TokenId;
    certificate: WatchCertificate;
  };

  public type ExtendedMetadataResult = Result<{
    certificate: WatchCertificate;
    token_id: TokenId;
  }, ApiError>;

  public type MetadataResult = Result<WatchCertificate, ApiError>;

  public type MetadataDesc = [MetadataPart];

  public type MetadataPart = {
    purpose: MetadataPurpose;
    key_val_data: [MetadataKeyVal];
    data: Blob;
  };

  public type MetadataPurpose = {
    #Preview;
    #Rendered;
  };
  
  public type MetadataKeyVal = {
    key: Text;
    val: MetadataVal;
  };

  public type MetadataVal = {
    #TextContent : Text;
    #BlobContent : Blob;
    #NatContent : Nat;
    #Nat8Content: Nat8;
    #Nat16Content: Nat16;
    #Nat32Content: Nat32;
    #Nat64Content: Nat64;
  };

  public type MintReceipt = Result<MintReceiptPart, ApiError>;

  public type MintReceiptPart = {
    token_id: TokenId;
    id: Nat;
  };

  public type WatchCertificate = {
    certificateCardId : Text;
    watchBrand : Text;
    watchModel : Text;
    watchYear : Text;
    jsonData: JsonData;
  };

  public type JsonData = {
    id: Text;
    createdAt: Text;
    inspectionDate: Text;
    updatedAt: Text;
    watchBrand: Text;
    watchModel: Text;
    generalCondition: Text;
    watchYearOrDecade: Text;
  }
};
