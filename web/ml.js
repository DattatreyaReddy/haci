async function classifyImage(url) {
    const img = document.getElementById('img');
    img.src = url;
    const model = await mobilenet.load();
    
    // CLASSIFY THE IMAGE
    let predictions = await model.classify(img);
    console.log('Pred >>>', predictions);
    return predictions
}