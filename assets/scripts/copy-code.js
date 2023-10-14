// Only add Copy buttons if the browser supports the Clipboard API
if (navigator.clipboard) {
    var codeBlocks = document.querySelectorAll('pre.highlight');
    var copyIcon = '<i class="far fa-copy"></i>';
    var copyDoneIcon = '<i class="fas fa-copy"></i>';

    codeBlocks.forEach(function (codeBlock) {
        var copyButton = document.createElement('button');
        copyButton.type = 'button';
        copyButton.value = 'Copy';
        copyButton.ariaLabel = 'Copy code to clipboard';
        copyButton.innerHTML = copyIcon;

        codeBlock.prepend(copyButton);

        copyButton.addEventListener('click', function () {
            var code = codeBlock.querySelector('code').innerText.trim();
            window.navigator.clipboard.writeText(code);

            copyButton.innerHTML = copyDoneIcon;

            setTimeout(function () {
                copyButton.innerHTML = copyIcon; // Reset icon
                copyButton.blur(); // Remove focus and let the button disappear
            }, 1000);
        });
    });
}
