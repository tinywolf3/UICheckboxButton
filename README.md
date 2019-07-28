# UICheckboxButton
Swift 5 Checkbox button

iPhone 앱에서 쓸만한 체크박스 버튼을 검색하다가 마음에 드는걸 찾는 시간보다 그냥 간단하게 만드는 시간이 더 빠를 것 같아 하나 만듦.

![](uicheckbox.gif)

swift를 사용한지 4개월밖에 되지 않았기 때문에 코드가 매우 유치할테지만 작동은 잘 됨.

스토리보드 디자이너에서 잘 작동함.

![](bullettype.gif)
![](bulletcolor.gif)

라디오그룹으로 묶기 위해서는 아래와 같이 하면 됨.

	@IBOutlet weak var chk1: UICheckboxButton!
	@IBOutlet weak var chk2: UICheckboxButton!
	@IBOutlet weak var chk3: UICheckboxButton!
	@IBOutlet weak var chk4: UICheckboxButton!
	@IBOutlet weak var chk5: UICheckboxButton!

	let _ = UICheckboxButton.RadioGroup(chk1, chk2, chk3, chk4, chk5)

	@IBAction func onCheck(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
	}

.
