const express=require('express');
const app =express();
var server= require('http').createServer(app);
const mongoose= require('mongoose');
const {Server}=require("socket.io");
const io=new Server(server);
const multer = require("multer");
const bodyParser = require("body-parser");
const path = require("path");
const ObjectId=mongoose.Types.ObjectId;
mongoose.connect(
    "mongodb://0.0.0.0:27017/ChatSocket",
    {
         useNewUrlParser: true, useUnifiedTopology: true},
        (err)=>{
            if (!err) console.log("base de donnée connectée");
            else console.log("base de donnée non connectée erreur: "+ err);
        
    }
)

require('./models/user.model');
require('./models/room.model');
require('./models/chat.model');
var User=mongoose.model('user');
var Room=mongoose.model('room');
var Chat=mongoose.model('chat');


//On définit le dossier contenant notre CSS et JS
app.use(express.static(__dirname + '/public'));
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.use(express.static(`${__dirname}/public`));
// Configurations for "body-parser"
app.use(
    bodyParser.urlencoded({
      extended: true,
    })
  );
  
  
  
  
  
  
  //Configuration for Multer
  const multerStorage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, "public");
    },
    filename: (req, file, cb) => {
      const ext = file.mimetype.split("/")[1];
      cb(null, `files/admin-${file.fieldname}-${Date.now()}.${ext}`);
    },
  });
  //const mimetype=['audio/mp3','audio/wav']
  //file.mimetype.split("/")[1] === "audio/mp3"
  const multerFilter = (req, file, cb) => {
    if (file.mimetype.split("/")[1] === 'wav'){
      cb(null, true);
    } else {
      cb(new Error("Not a audio File!!"), false);
    }
  };
  
  const upload = multer({
    storage: multerStorage,
    fileFilter: multerFilter,
  });
//ROUTER
app.get('/', function(req, res) {
    User.find((err, users) => {
        if(users) { 
            Room.find((err, channels) => {
                if(channels){
                    res.render('index.ejs', {users: users, channels: channels});
                }
                else {

                    res.render('index.ejs', {users: users});
                }
            });
        } else {
            Room.find((err, channels) => {
                if(channels){
                    res.render('index.ejs', {channels: channels});
                }
                else {

                    res.render('index.ejs');
                }
            });
        }
    });
});

//404
app.use(function(req, res, next) {
    res.setHeader('Content-type', 'text/html');
    res.status(404).send('Page introuvable !');
});


// IO

//var io = require('socket.io').listen(server);
var connectedUsers = []

// Lorsqu'une personne arrive sur la vue index.ejs, la fonction ci-dessous se lance
io.on('connection', (socket) => {
    
    // On recoit 'pseudo' du fichier html
    socket.on('pseudo', (pseudo) => {
        
        User.findOne({ pseudo: pseudo }, (err, user) => {
            if(user) {

                // On join automatiquement le channel "salon1" par défaut
                _joinRoom("salon1");

                // On conserve le pseudo dans la variable socket qui est propre à chaque utilisateur
                socket.pseudo = pseudo;
                connectedUsers.push(socket);
                // On previent les autres
                socket.broadcast.to(socket.channel).emit('newUser', pseudo);

            } else {
                var user = new User();
                user.pseudo = pseudo;
                user.save();

                // On join automatiquement le channel "salon1" par défaut
                _joinRoom("salon1");

                socket.pseudo = pseudo;
                connectedUsers.push(socket)
                socket.broadcast.to(socket.channel).emit('newUser', pseudo);
                socket.broadcast.emit('newUserInDb', pseudo);
            }
        })

    });

    socket.on('oldWhispers', (pseudo) => {
        let messagesList = [];
        Chat.find({ sender:pseudo }, (err, messages) => {

            if(err) {
                return false;
            } else {
                messagesList = messagesList.concat(messages);
                
            }

        })

        Chat.find({receiver:pseudo}, (err, messages) => {
            if(err){
                return false;
            } else {
                messagesList = messagesList.concat(messages);
                const sortedMessages = messagesList.sort(function (x, y) {
                    let a = x.createdAt,
                        b = y.createdAt;
                    return a - b;
                })
                socket.emit('oldWhispers', sortedMessages)
            }
        })

    });

    socket.on('changeChannel', (channel) => {
        _joinRoom(channel);
    });

    // Quand un nouveau message est envoyé
    socket.on('newMessage', ( param)=> {
        const receiver = JSON.parse(param).receiver;
        const message = JSON.parse(param).message;
        if(receiver === "all") { 

    //--------------------------------------------------------------










    //-------------------------------------------------------------





            var chat = new Chat();
            chat._id_room = socket.channel;
            chat.sender = socket.pseudo;
            chat.receiver = receiver;
            chat.content = message;
            chat.save();

            socket.broadcast.to(socket.channel).emit('newMessageAll', {message: message, pseudo: socket.pseudo});

        } else {

            User.findOne({pseudo: receiver}, (err, user) => {
                if(!user) {
                    return false
                } else {
                    
                    socketReceiver = connectedUsers.find(element => element.pseudo === user.pseudo)

                    if(socketReceiver) {
                        socketReceiver.emit('whisper', { sender: socket.pseudo, message: message })
                    }

                    var chat = new Chat();
                    chat.sender = socket.pseudo;
                    chat.receiver = receiver;
                    chat.content = message;
                    chat.save();

                }
            })

        }

    });

    // Quand un user se déconnecte
    socket.on('disconnect', () => {
        var index = connectedUsers.indexOf(socket)
        if(index > -1) {
            connectedUsers.splice(index, 1)
        }
        socket.broadcast.to(socket.channel).emit('quitUser', socket.pseudo);
    });

    socket.on('writting', (pseudo) => {
        socket.broadcast.to(socket.channel).emit('writting', pseudo);
    });

    socket.on('notWritting', (pseudo) => {
        socket.broadcast.to(socket.channel).emit('notWritting', pseudo);
    });


    function _joinRoom(channelParam) {

        //Si l'utilisateur est déjà dans un channel, on le stock
        var previousChannel = ''
        if(socket.channel) {
            previousChannel = socket.channel; 
        }

        //On quitte tous les channels et on rejoint le channel ciblé
        socket.leaveAll();
        socket.join(channelParam);
        socket.channel = channelParam;

        Room.findOne({name: socket.channel}, (err, channel) => {
            if(channel){
                Chat.find({_id_room: socket.channel}, (err, messages) => {
                    if(!messages){
                        return false;
                    }
                    else{
                        socket.emit('oldMessages', messages, socket.pseudo);
                        //Si l'utilisateur vient d'un autre channel, on le fait passer, sinon on ne fait passer que le nouveau
                        if(previousChannel) {
                            socket.emit('emitChannel', {previousChannel: previousChannel, newChannel: socket.channel});
                        } else {
                            socket.emit('emitChannel', {newChannel: socket.channel});
                        }
                    }
                });
            }
            else {
                var room = new Room();
                room.name = socket.channel;
                room.save();
                
                socket.broadcast.emit('newChannel', socket.channel);
                socket.emit('emitChannel', {previousChannel: previousChannel, newChannel: socket.channel});
            }
        })
    }

});




//API Endpoint for uploading file
app.post("/api/uploadFile", upload.single("myFile"), async (req, res) => {
    // 
    console.log(req.file);
    try {
      const newFile = await Chat.create({
        name: req.file.filename,
      });
      res.status(200).json({
        status: "success",
        message: "File created successfully!!",
      });
    } catch (error) {
      res.json({
        error,
      });
    }
  });

  app.get("/api/getFiles", async (req, res) => {
    try {
      const files = await Chat.find();
      res.status(200).json({
        status: "success",
        files,
      });
    } catch (error) {
      res.json({
        status: "Fail",
        error,
      });
    }
  });



server.listen(300,()=>console.log("server start!"));
