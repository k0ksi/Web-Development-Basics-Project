<div class="row">
    <?php
    foreach ($this->_viewBag['body']->getConferences() as $conference) :?>
        <div class="panel panel-default col-md-5 margin-right">
            <div class="panel-body">
                <div class="block">
                    <a class="panel panel-primary col-sm-4 btn btn-default text-center"
                       href="/conference/<?= $conference->getId() ?>/show/0/3"><?= $conference->getName() ?></a>
                    <p>&nbsp;&nbsp;&nbsp;&nbsp;<i><?= $conference->getDescription() ?></i></p>
                </div>
                <div class="block margin-top">
                    <p><b>Start:</b> <?= date_format(date_create($conference->getStart()), 'd F Y')?></p>
                    <p><b>End:</b> <?= date_format(date_create($conference->getEnd()), 'd F Y') ?></p>
                    <p><b>Owner:</b> <?= $conference->getOwner() ?></p>
                    <p><b>Venue:</b> <?= $conference->getVenue() ?></p>
                    <?php if(!(count($conference->getAdmins()) < 1)) :?>
                        <p><b>Administrators: </b><?= implode(', ', $conference->getAdmins()) ?></p>
                    <?php endif; ?>
                    <?php if((count($conference->getAdmins()) < 1)) :?>
                        <p><i>No administrators registered at this point.</i></p>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    <?php endforeach; ?>
</div>