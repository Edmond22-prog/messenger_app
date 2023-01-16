const mongoose=require('mongoose');

var chatSchema= new mongoose.Schema({
    _id_room:{
        type:String
    },
   
    createdAt: {
        type: Date,
        default: Date.now,
      }, 
    
    sender:String,
    receiver:String,
    content:{
        type: String,
        required: [true, "Uploaded file must have a name"],//pour ajouter l'audion
      },
      statut:String,

});



mongoose.model('chat',chatSchema);