// Swift Schulung

// Leerer TableViewController der nicht von UITableViewController erbt

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Table Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // If there is just one section, we just return 1.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The number of rows
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MessageCell
        
        // Apply all customizations to this cell
        
        return cell
    }
    
    // Mark: - Table delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Usually you do not overwrite this method. 
        // The default value is 40.0 anyway. 
        // If you want to use a different height than 40.0 then just set the self.tableView.rowHeight = 42
        
        // However, if the height of the cell is not constant but varies depending on its content or 
        // cell type, then - and only hten - you should implement this method and return the 
        // accurate height for each of the cells. 
        
        return 42.0
        
    }
    
}
