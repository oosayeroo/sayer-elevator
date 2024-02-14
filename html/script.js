let UIPosition = 'right'; // Possible values: 'center', 'left', 'right'

function updateUIPosition() {
    switch (UIPosition) {
        case 'center':
            elevatorPanel.style.top = "50%";
            elevatorPanel.style.left = "50%";
            elevatorPanel.style.right = "";
            elevatorPanel.style.transform = "translate(-50%, -50%)";
            break;
        case 'left':
            elevatorPanel.style.top = "50%";
            elevatorPanel.style.left = "20px";
            elevatorPanel.style.right = "";
            elevatorPanel.style.transform = "translate(0, -50%)";
            break;
        case 'right':
            elevatorPanel.style.top = "50%";
            elevatorPanel.style.right = "20px"; 
            elevatorPanel.style.left = "";
            elevatorPanel.style.transform = "translate(0, -50%)";
            break;
        default:
            // Default to center if any spelling errors
            elevatorPanel.style.top = "50%";
            elevatorPanel.style.left = "50%";
            elevatorPanel.style.transform = "translate(-50%, -50%)";
    }
}

let lastSelectedFloor = null;
const elevatorPanel = document.getElementById('elevatorPanel');
const floorDisplay = document.getElementById('floorDisplay');
const buttonGrid = document.createElement('div');
buttonGrid.classList.add('button-grid');
const elevatorFooter = document.querySelector('.elevator-footer');

function OpenUI(currentFloorId, floorsData) {
    elevatorPanel.style.display = 'flex';

    while (buttonGrid.firstChild) {
        buttonGrid.removeChild(buttonGrid.firstChild); 
    }

    if (!elevatorPanel.contains(buttonGrid)) {
        elevatorPanel.insertBefore(buttonGrid, elevatorFooter); 
    }

    let currentlySelectedButton = null;

    floorsData.forEach(floor => {
        const button = document.createElement('button');
        button.textContent = floor.Label;
        button.classList.add('button');
        button.onclick = () => {
            floorDisplay.textContent = floor.Label;
            lastSelectedFloor = floor;

            if (currentlySelectedButton) {
                currentlySelectedButton.classList.remove('button-selected');
            }

            button.classList.add('button-selected');

            currentlySelectedButton = button;
        };
        buttonGrid.appendChild(button);
    });

    let closeDoorsButton = elevatorPanel.querySelector('.close-doors');
    if (!closeDoorsButton) {
        closeDoorsButton = document.createElement('button');
        closeDoorsButton.classList.add('button', 'close-doors');
        closeDoorsButton.innerHTML = '&#x25B6;&#x2502;&#x25C0;'; 
        closeDoorsButton.onclick = () => {
            if (lastSelectedFloor) {
                GoToFloor();
            }
        };
        elevatorPanel.insertBefore(closeDoorsButton, elevatorFooter);
    }

    const currentFloor = floorsData.find(floor => floor.ID === currentFloorId);
    if (currentFloor) {
        floorDisplay.textContent = currentFloor.Label;
        lastSelectedFloor = currentFloor;
    }
    updateUIPosition();
}

function GoToFloor() {
    fetch(`https://sayer-elevator/go-to-floor`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ floor:lastSelectedFloor })
    }).then(response => response.json())
      .then(data => {
          console.log(data);
          elevatorPanel.style.display = 'none';
          lastSelectedFloor = null;
      })
      .catch(error => {
          console.error('Error:', error);
          elevatorPanel.style.display = 'none';
      });
}

window.addEventListener('message', (event) => {
    if (event.data.action === 'open-elevator') {
        UIPosition = event.data.UIPosition;
        OpenUI(event.data.CurrentFloor, event.data.Floors);
    }
});
