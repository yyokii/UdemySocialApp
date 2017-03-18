//
//  PostCell.swift
//  UdemySocialApp
//
//  Created by 東原与生 on 2017/03/18.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profieImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImag: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell (post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
    }
    
}
