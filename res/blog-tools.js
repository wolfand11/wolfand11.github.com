function slideShow(groupIdx, imgIdx) {
    container = document.getElementById("imgGroup" + groupIdx);
    if (container == null) return;

    for (i = 0; i < container.childElementCount; i++) {
        if (i == imgIdx) {
            container.children[i].style.display = "block";
        }
        else {
            container.children[i].style.display = "none";
        }
    }
    curImgIdxLabel = document.getElementById("curImgIdx" + groupIdx)
    if (curImgIdxLabel == null) return;
    curImgIdxLabel.innerHTML = imgIdx;
};

function slideShowInit() {
    for (groupIdx = 0; groupIdx < 10; groupIdx++) {
        container = document.getElementById("imgGroup" + groupIdx);

        if (container == null) return;
        slideShow(groupIdx, 0)
    }
}

// main
function init_blog_tools()
{
    // init slide show
    slideShowInit();
}
init_blog_tools();