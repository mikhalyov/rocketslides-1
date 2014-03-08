gh-pages:
	rm -rf ../rocketslides-html
	git clone git@github.com:mikhalyov/mikhalyov.github.io ../rocketslides-html
	grunt build
	cd ../rocketslides-html && git add .
	cd ../rocketslides-html && git commit -m 'sync' -a
	cd ../rocketslides-html && git push origin master
	rm -rf ../rocketslides-html
	git clone git@github.com:rocketslides/rocketslides.github.io ../rocketslides-html
	grunt build
	cd ../rocketslides-html && git add .
	cd ../rocketslides-html && git commit -m 'sync' -a
	cd ../rocketslides-html && git push origin master
