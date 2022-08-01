import express from "express";
import multer from "multer";
import path from "path";
const router = express.Router();

const storage = multer.diskStorage({
  destination(req, file, cb) {
    cb(null, "uploads");
  },
  filename(req, file, cb) {
    cb(
      null,
      `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`
    );
  },
});

function checkFileType(file, cb) {
  const filetypes = /jpg|jpeg|png/;
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  const mimetype = filetypes.test(file.mimetype);

  if (extname && mimetype) {
    return cb(null, true);
  } else {
    cb("Images only!");
  }
}

export const upload = multer({
  storage,
  // fileFilter: function (req, file, cb) {
  //   checkFileType(file, cb);
  // },
});

router.post("/", upload.single("image"), (req, res) => {
  console.log(req.file.path);
  // res.send(`/${req.file.path}`);
  res.json({path:`${req.file.path.split("\\")[1]}`})
});

export default router;