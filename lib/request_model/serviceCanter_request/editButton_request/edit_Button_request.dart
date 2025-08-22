
class EditButtonRequest{
   String? companyId;
   String? id;
   String? name;
   String? hotlineNo;
   String? email;

   EditButtonRequest({
     this.id,
     this.companyId,
     this.email,
     this.hotlineNo,
     this.name
});

   Map<String,dynamic>toJson(){
     return{
       "name": name,
       "hotlineNo": hotlineNo,
       "email": email,
     };
   }
}